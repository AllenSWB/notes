//
//  NSObject+RACKVOWrapper.m
//  ReactiveObjC
//
//  Created by Josh Abernathy on 10/11/11.
//  Copyright (c) 2011 GitHub. All rights reserved.
//

#import "NSObject+RACKVOWrapper.h"
#import <ReactiveObjC/RACEXTRuntimeExtensions.h>
#import <ReactiveObjC/RACEXTScope.h>
#import "NSObject+RACDeallocating.h"
#import "NSString+RACKeyPathUtilities.h"
#import "RACCompoundDisposable.h"
#import "RACDisposable.h"
#import "RACKVOTrampoline.h"
#import "RACSerialDisposable.h"

@implementation NSObject (RACKVOWrapper) // wrapper /ræpər/ 包装材料

- (RACDisposable *)rac_observeKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options observer:(__weak NSObject *)weakObserver block:(void (^)(id, NSDictionary *, BOOL, BOOL))block {
	NSCParameterAssert(block != nil);
	NSCParameterAssert(keyPath.rac_keyPathComponents.count > 0);

    
    // ⚠️ 上半部分做了一大堆关于 Disposable 销毁信号准备工作 ,下半部分做了销毁操作
	keyPath = [keyPath copy];

	NSObject *strongObserver = weakObserver;

	NSArray *keyPathComponents = keyPath.rac_keyPathComponents;
	BOOL keyPathHasOneComponent = (keyPathComponents.count == 1);
	NSString *keyPathHead = keyPathComponents[0];
	NSString *keyPathTail = keyPath.rac_keyPathByDeletingFirstKeyPathComponent;

	RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];

	// The disposable that groups all disposal necessary to clean up the callbacks
	// added to the value of the first key path component.
	RACSerialDisposable *firstComponentSerialDisposable = [RACSerialDisposable serialDisposableWithDisposable:[RACCompoundDisposable compoundDisposable]];
	RACCompoundDisposable * (^firstComponentDisposable)(void) = ^{
		return (RACCompoundDisposable *)firstComponentSerialDisposable.disposable;
	};

	[disposable addDisposable:firstComponentSerialDisposable];

	BOOL shouldAddDeallocObserver = NO;

	objc_property_t property = class_getProperty(object_getClass(self), keyPathHead.UTF8String);
	if (property != NULL) {
		rac_propertyAttributes *attributes = rac_copyPropertyAttributes(property);
		if (attributes != NULL) {
			@onExit {
				free(attributes);
			};

			BOOL isObject = attributes->objectClass != nil || strstr(attributes->type, @encode(id)) == attributes->type;
			BOOL isProtocol = attributes->objectClass == NSClassFromString(@"Protocol");
			BOOL isBlock = strcmp(attributes->type, @encode(void(^)(void))) == 0;
			BOOL isWeak = attributes->weak;

			// If this property isn't actually an object (or is a Class object),
			// no point in observing the deallocation of the wrapper returned by
			// KVC.
			//
			// If this property is an object, but not declared `weak`, we
			// don't need to watch for it spontaneously being set to nil.
			//
			// Attempting to observe non-weak properties will result in
			// broken behavior for dynamic getters, so don't even try.
			shouldAddDeallocObserver = isObject && isWeak && !isBlock && !isProtocol;
		}
	}

	// Adds the callback block to the value's deallocation. Also adds the logic to
	// clean up the callback to the firstComponentDisposable.
	void (^addDeallocObserverToPropertyValue)(NSObject *) = ^(NSObject *value) {
		if (!shouldAddDeallocObserver) return;

		// If a key path value is the observer, commonly when a key path begins
		// with "self", we prevent deallocation triggered callbacks for any such key
		// path components. Thus, the observer's deallocation is not considered a
		// change to the key path.
		if (value == weakObserver) return;

		NSDictionary *change = @{
			NSKeyValueChangeKindKey: @(NSKeyValueChangeSetting),
			NSKeyValueChangeNewKey: NSNull.null,
		};

		RACCompoundDisposable *valueDisposable = value.rac_deallocDisposable;
		RACDisposable *deallocDisposable = [RACDisposable disposableWithBlock:^{
			block(nil, change, YES, keyPathHasOneComponent);
		}];

		[valueDisposable addDisposable:deallocDisposable];
		[firstComponentDisposable() addDisposable:[RACDisposable disposableWithBlock:^{
			[valueDisposable removeDisposable:deallocDisposable];
		}]];
	};

	// Adds the callback block to the remaining path components on the value. Also
	// adds the logic to clean up the callbacks to the firstComponentDisposable.
	void (^addObserverToValue)(NSObject *) = ^(NSObject *value) {
		RACDisposable *observerDisposable = [value rac_observeKeyPath:keyPathTail options:(options & ~NSKeyValueObservingOptionInitial) observer:weakObserver block:block];
		[firstComponentDisposable() addDisposable:observerDisposable];
	};
    
    /* ⚠️ 传值监听过程  
      KVO: 面向对象 ， 谁调用谁被监听
      此处把所有的相关参数传入，如：观察者，被观察对象，keyPath 等，
      用 RACKVOTrampoling  进行了封装，此类是监听工作开始的起点，block的回调得到监听的最终结果
    */
	NSKeyValueObservingOptions trampolineOptions = (options | NSKeyValueObservingOptionPrior) & ~NSKeyValueObservingOptionInitial;
    // rampoline /ˈtræmpəˌlin/ 蹦床
	RACKVOTrampoline *trampoline = [[RACKVOTrampoline alloc] initWithTarget:self observer:strongObserver keyPath:keyPathHead options:trampolineOptions block:^(id trampolineTarget, id trampolineObserver, NSDictionary *change) {
		/*
        RACKVOTrampoline.m 里的响应监听方法
        - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
         会把新值 Block 到这里来
          */
		if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) {
			[firstComponentDisposable() dispose];

			if ((options & NSKeyValueObservingOptionPrior) != 0) {
				block([trampolineTarget valueForKeyPath:keyPath], change, NO, keyPathHasOneComponent);
			}

			return;
		}

		// From here the notification is not prior.
		NSObject *value = [trampolineTarget valueForKey:keyPathHead];

		// If the value has changed but is nil, there is no need to add callbacks to
		// it, just call the callback block.
		if (value == nil) {
			block(nil, change, NO, keyPathHasOneComponent);
			return;
		}

        
        // 销毁操作
		RACDisposable *oldFirstComponentDisposable = [firstComponentSerialDisposable swapInDisposable:[RACCompoundDisposable compoundDisposable]];
		[oldFirstComponentDisposable dispose];

		addDeallocObserverToPropertyValue(value);

		// If there are no further key path components, there is no need to add the
		// other callbacks, just call the callback block with the value itself.
		if (keyPathHasOneComponent) {
			block(value, change, NO, keyPathHasOneComponent);
			return;
		}
 
		addObserverToValue(value);
        
        // block  返回到 （NSObject + RACPropertySubscribing.m) 的信号量定义 block里， 并 sendNext
		block([value valueForKeyPath:keyPathTail], change, NO, keyPathHasOneComponent);
	}];

	// Stop the KVO observation when this one is disposed of.
	[disposable addDisposable:trampoline];

	// Add the callbacks to the initial value if needed.
	NSObject *value = [self valueForKey:keyPathHead];
	if (value != nil) {
		addDeallocObserverToPropertyValue(value);

		if (!keyPathHasOneComponent) {
			addObserverToValue(value);
		}
	}

	// Call the block with the initial value if needed.
	if ((options & NSKeyValueObservingOptionInitial) != 0) {
		id initialValue = [self valueForKeyPath:keyPath];
		NSDictionary *initialChange = @{
			NSKeyValueChangeKindKey: @(NSKeyValueChangeSetting),
			NSKeyValueChangeNewKey: initialValue ?: NSNull.null,
		};
		block(initialValue, initialChange, NO, keyPathHasOneComponent);
	}


	RACCompoundDisposable *observerDisposable = strongObserver.rac_deallocDisposable;
	RACCompoundDisposable *selfDisposable = self.rac_deallocDisposable;
	// Dispose of this observation if the receiver or the observer deallocate.
	[observerDisposable addDisposable:disposable];
	[selfDisposable addDisposable:disposable];

	return [RACDisposable disposableWithBlock:^{
		[disposable dispose];
		[observerDisposable removeDisposable:disposable];
		[selfDisposable removeDisposable:disposable];
	}];
}

@end
