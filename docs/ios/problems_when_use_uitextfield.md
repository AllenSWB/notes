## 使用UITextField常见的几个问题

1. 右对齐时输入空格不显示
2. 屏蔽三方键盘
3. 密码输入框明文密文切换，光标位置不对
4. iOS10系统以下，输入时文本过长后，光标不自动左移

---

1. 右对齐时输入空格不显示

    解决 ： 自定义TextField

        //1. 自定义TextField       
        
        // .h
        @interface MTTextField : UITextField
        @end

        //.m
        @implementation MTTextField
        - (instancetype)init {
            self = [super init];
            if (self) {
                [self addTarget:self action:@selector(replaceNormalSpaceUsingNonbreakingSpace)
            forControlEvents:UIControlEventEditingChanged];
            }
            return self;
        }

        - (void)replaceNormalSpaceUsingNonbreakingSpace {
            UITextRange *textRange = self.selectedTextRange;
            self.text = [self.text stringByReplacingOccurrencesOfString:@" "
                                                withString:@"\u00a0"];
            [self setSelectedTextRange:textRange];
        }

        //2. 使用的时候
        [[MTObserve(cell.textField, text) skip:1] subscribeNext:^(NSString *x) {
            @strongify(self)
            NSString *text = [x stringByReplacingOccurrencesOfString:@"\u00a0" withString:@" "];
            self.modifyInfoViewModel.nickname = [text trim];
        }];

2. 屏蔽三方键盘

        //1. 全局禁第三方键盘
        - (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
        {
            return NO;
        }

        //2. 某个uitextfield禁第三方键盘  

        // [原文](https://www.pixotech.com/ios8_third_party_custom_keyboard_compatibility/)
        #pragma mark - 禁用三方键盘
        - (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier {
            if ([extensionPointIdentifier isEqualToString: UIApplicationKeyboardExtensionPointIdentifier]) {
                id responder = [self findFirstResponder];
                if ([responder isKindOfClass:[UITextField class]]) {
                    return NO;
                }
            }
            return YES;
        }

        id mt_firstResponder;

        -(id)findFirstResponder {
            mt_firstResponder = nil;
            [[UIApplication sharedApplication] sendAction:@selector(foundFirstResponder:) to:nil from:nil forEvent:nil];
            return mt_firstResponder;
        }
        -(void)foundFirstResponder:(id)sender {
            mt_firstResponder = self;
        }


3. 密码输入框明文密文切换，光标位置不对

        [[self.showPasswdButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.viewModel.loginBussiness.showPasswd = !self.viewModel.loginBussiness.showPasswd;

            // 第一种方式
            // NSString *temp = self.viewModel.loginBussiness.passwd;
            // self.passwdInputView.textField.text = @"";
            // self.passwdInputView.textField.text = temp;

            // 第二种方式
            if (self.passwdInputView.textField.isFirstResponder) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self)
                    [self.passwdInputView.textField becomeFirstResponder];
                }
            }
        }]


4. iOS10系统以下，输入时文本过长后，光标不自动左移

    解决： 增加uitextfield高度

