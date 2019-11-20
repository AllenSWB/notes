//
//  NSObject+RACPropertySubscribing.m
//  ReactiveObjC
//
//  Created by Josh Abernathy on 3/2/12.
//  Copyright (c) 2012 GitHub, Inc. All rights reserved.
//

#import "NSObject+RACPropertySubscribing.h"
#import <ReactiveObjC/RACEXTScope.h>
#import "NSObject+RACDeallocating.h"
#import "NSObject+RACDescription.h"
#import "NSObject+RACKVOWrapper.h"
#import "RACCompoundDisposable.h"
#import "RACDisposable.h"
#import "RACKVOTrampoline.h"
#import "RACSubscriber.h"
#import "RACSignal+Operations.h"
#import "RACTuple.h"
#import <libkern/OSAtomic.h>

@implementation NSObject (RACPropertySubscribing)

- (RACSignal *)rac_valuesForKeyPath:(NSString *)keyPath observer:(__weak NSObject *)observer {
	return [[[self
		rac_valuesAndChangesForKeyPath:keyPath options:NSKeyValueObservingOptionInitial observer:observer]
		map:^(RACTuple *value) {
			// -map: because it doesn't require the block trampoline that -reduceEach: uses
			return value[0];
		}]
		setNameWithFormat:@"RACObserve(%@, %@)", RACDescription(self), keyPath];
}

- (RACSignal *)rac_valuesAndChangesForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options observer:(__weak NSObject *)weakObserver {
	NSObject *strongObserver = weakObserver;
	keyPath = [keyPath copy];

    // 产生了一个递归锁
	NSRecursiveLock *objectLock = [[NSRecursiveLock alloc] init];
	objectLock.name = @"org.reactivecocoa.ReactiveObjC.NSObjectRACPropertySubscribing";

	__weak NSObject *weakSelf = self;
    
    // 创建了一个 销毁信号量， 假如：vc 调用了 RACObserve(TARGET, KEYPATH)，但vc被销毁了，这个信号就会发出一个销毁信号
	RACSignal *deallocSignal = [[RACSignal
		zip:@[
			self.rac_willDeallocSignal,
			strongObserver.rac_willDeallocSignal ?: [RACSignal never]
		]]
		doCompleted:^{
			// Forces deallocation to wait if the object variables are currently
			// being read on another thread.
			[objectLock lock];
			@onExit {
				[objectLock unlock];
			};
		}];
    
    //  takeUntil:deallocSignal  判断当前观察者是否销毁了，如果销毁了就不会对进入以下监听工作 
	return [[[RACSignal
		createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
			// Hold onto the lock the whole time we're setting up the KVO
			// observation, because any resurrection that might be caused by our
			// retaining below must be balanced out by the time -dealloc returns
			// (if another thread is waiting on the lock above).
			[objectLock lock];
			@onExit {
				[objectLock unlock];
			};

			__strong NSObject *observer __attribute__((objc_precise_lifetime)) = weakObserver;
			__strong NSObject *self __attribute__((objc_precise_lifetime)) = weakSelf;

			if (self == nil) {
				[subscriber sendCompleted];
				return nil;
			}
            // 以下方法进行传值监听, 看这里 ⚠️
			return [self rac_observeKeyPath:keyPath options:options observer:observer block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
                /*
                    将得到的新值通过block回调到这里，
                    并使用 sendNext 发送出去外部订阅的 subscribeNext
                 */
				[subscriber sendNext:RACTuplePack(value, change)];
			}];
		}]
		takeUntil:deallocSignal]
		setNameWithFormat:@"%@ -rac_valueAndChangesForKeyPath: %@ options: %lu observer: %@", RACDescription(self), keyPath, (unsigned long)options, RACDescription(strongObserver)];
}

@end
