//
//  ViewController.m
//  ReactiveCocoaLearn
//
//  Created by 刘乙灏 on 2017/9/7.
//  Copyright © 2017年 刘乙灏. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry.h>

@interface ViewController () <UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 事件监听、通知中心、延时、定时器、代理
//    [self demo1];
    
    // KVO
//    [self demo2];

    // 创建、发送、销毁信号
//    [self demo3];
    
    // map映射替换，filter判断，RAC()宏绑定，
//    [self demo4];
    
    // 用UISlider实现调色板
//    [self demo5];
    
    // 报时demo
//    [self demo6];
    
    // 简洁代码实现登录逻辑
//    [self demo7];
    
    // 模拟消息发送，绑定到控件
//    [self demo8];
    
    // 信号拼接concat，顺序执行，上一个信号completed才会执行下一个信号
//    [self demo9];
    
    // 信号合并merge，任意信号有发送就会执行
//    [self demo10];
    
    // 信号组合combineLatest
//    [self demo11];
    
    // 信号压缩zip
//    [self demo12];
    
    // 信号传递flattenMap
//    [self demo13];
    
    // 信号串then, 不传递value
//    [self demo14];
    
    // command
//    [self demo15];
    
    // rac的一些修饰符
    [self demo16];
}

/**
 *  rac的一些修饰符
 */
- (void)demo16 {
//    // 延迟delay
//    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [subscriber sendNext:@"RAC信号延迟----等等我~等我2秒"];
//        [subscriber sendCompleted];
//        return nil;
//    }] delay:2] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"RAC信号延迟-----终于等到你~");
//    }];
//    
//    // 定时任务
//    [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
//        NSLog(@"一秒钟吃一颗药，药不能停");
//    }];
//    
//    // 设置超时时间
//    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            [subscriber sendNext:@"hh"];
//            [subscriber sendCompleted];
//            return nil;
//        }] delay:4] subscribeNext:^(id  _Nullable x) {
//            NSLog(@"RAC设置超时时间-----请求到数据：%@", x);
//            [subscriber sendNext:[@"RAC设置超时时间------请求到数据-----:" stringByAppendingString:x]];
//            [subscriber sendCompleted];
//        }];
//        return nil;
//    }] timeout:3 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"请求到的数据%@", x);
//    }];
//    
//    // 设置retry次数，这部分可以和网络请求一起用
//    __block int retry_idx = 0;
//    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        if (retry_idx < 3) {
//            retry_idx ++;
//            [subscriber sendError:nil];
//        } else {
//            [subscriber sendNext:@"success!"];
//            [subscriber sendCompleted];
//        }
//        return nil;
//    }] retry:3] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"请求：%@", x);
//    }];
//    
//    // 节流阀,throttle秒内只能通过1个消息
//    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:@"6"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@"66"];
//        });
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@"666"];
//            [subscriber sendCompleted];
//        });
//        
//        return nil;
//    }] throttle:2] subscribeNext:^(id x) {
//        //throttle: N   N秒之内只能通过一个消息，所以@"6"是不会被发出的
//        NSLog(@"RAC_throttle------result = %@",x);
//    }];
    
    // 条件控制takeUntil 解释：`takeUntil:(RACSignal *)signalTrigger` 只有当`signalTrigger`这个signal发出消息才会停止
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            [subscriber sendNext:@"吃饭中~"];
        }];
        return nil;
    }] takeUntil:[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"RAC_Condition------吃饱了~");
            [subscriber sendNext:@"吃饱啦"];
        });
        return nil;
    }]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

/**
 *  command
 */
- (void)demo15 {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"亲，帮我带份饭");
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [command execute:nil];
}

/**
 *  信号串then, 不传递value
 */
- (void)demo14 {
    //与信号传递类似，不过使用 `then` 表明的是秩序，没有传递value
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"RAC信号串------打开冰箱");
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"RAC信号串------把大象放进冰箱");
            [subscriber sendCompleted];
            return nil;
        }];
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"RAC信号串------关上冰箱门");
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        NSLog(@"RAC信号串------Over");
    }];
}

/**
 *  信号传递flattenMap
 */
- (void)demo13 {
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"老板想我扔过来一个Star"];
        return nil;
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSLog(@"%@", value);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"我向老板扔了一块板砖"];
            return nil;
        }];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSLog(@"%@", value);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"我和老板刚正面，结果可想而知"];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

/**
 *  信号压缩zip
 */
- (void)demo12 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"年轻"];
        [subscriber sendNext:@"清纯"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"温柔"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //zip 默认会取信号量的最开始发送的对象，所以结果会是 年轻、温柔
    [[RACSignal zip:@[signal1, signal2]] subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(NSString *signal1, NSString *signal2) = x;
        NSLog(@"RAC信号压缩------我喜欢 %@的 %@的 妹子", signal1, signal2);
    }];
}

/**
 *  信号组合combineLatest
 */
- (void)demo11 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"年轻"];
        [subscriber sendNext:@"清纯"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"温柔"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    //combineLatest 将数组中的信号量发出的最后一个object 组合到一起
    [[RACSignal combineLatest:@[signal1, signal2]] subscribeNext:^(RACTuple *x) {
        //先进行解包
        RACTupleUnpack(NSString *signal1_Str, NSString *signal2_Str) = x;
        NSLog(@"RAC信号组合------我喜欢 %@的 %@的 妹子",signal1_Str,signal2_Str);
    }];
    
    //会注意收到 组合方法后还可以跟一个Block  /** + (RACSignal *)combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock */
    /*
     reduce这个Block可以对组合后的信号量做处理
     */
    //我们还可以这样使用
    [[RACSignal combineLatest:@[signal1, signal2] reduce:^(NSString *signal1_Str, NSString *signal2_Str){
        return [signal1_Str stringByAppendingString:signal2_Str];
    }] subscribeNext:^(id x) {
        NSLog(@"RAC信号组合(Reduce处理)------我喜欢 %@ 的妹子",x);
    }];
}

/**
 *  信号合并merge，任意信号有发送就会执行
 */
- (void)demo10 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"清纯妹子"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"性感妹子"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    [[signal1 merge:signal2] subscribeNext:^(id x) {
        NSLog(@"RAC信号合并------我喜欢： %@",x);
    }];
}

/**
 *  信号拼接concat，顺序执行，上一个信号completed才会执行下一个信号
 */
- (void)demo9 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted]; //关键
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(2)];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    [[signal1 concat:signal2] subscribeNext:^(NSNumber *value) {
        NSLog(@"RAC信号拼接------value = %@",value);
    }];
}

/**
 *  模拟消息发送，绑定到控件
 */
- (void)demo8 {
    UITextField *userNameField = [[UITextField alloc] init];
    userNameField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:userNameField];
    
    [userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"呵呵哒~"];
//        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号取消订阅");
        }];
    }];
    
    RAC(userNameField, text) = [signal map:^id _Nullable(id  _Nullable value) {
        if ([value isEqualToString:@"呵呵哒~"]) {
            return @"么么哒~";
        }
        return nil;
    }];
}

/**
 *  简洁代码实现登录逻辑
 */
- (void)demo7 {
    UITextField *accountTxt = [[UITextField alloc] init];
    accountTxt.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:accountTxt];
    
    UITextField *pwdTxt = [[UITextField alloc] init];
    pwdTxt.borderStyle = UITextBorderStyleRoundedRect;
    pwdTxt.secureTextEntry = YES;
    [self.view addSubview:pwdTxt];
    
    UILabel *agreeLabel = [[UILabel alloc] init];
    agreeLabel.text = @"同意条款";
    [self.view addSubview:agreeLabel];
    
    UISwitch *agreeSw = [[UISwitch alloc] init];
    [self.view addSubview:agreeSw];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"注册按钮" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.view addSubview:loginBtn];
    
    [accountTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [pwdTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(accountTxt.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdTxt.mas_bottom).offset(20);
        make.left.equalTo(pwdTxt).offset(0);
    }];
    
    [agreeSw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(agreeLabel);
        make.right.equalTo(pwdTxt).offset(0);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreeLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    loginBtn.enabled = NO;
    
    RAC(loginBtn, enabled) = [RACSignal combineLatest:@[accountTxt.rac_textSignal, pwdTxt.rac_textSignal, agreeSw.rac_newOnChannel] reduce:^id _Nullable (NSString *account, NSString * pwd, NSNumber *isOn){
        return @(account.length && pwd.length && isOn.boolValue);
    }];
}

/**
 *  报时demo
 */
- (void)demo6 {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor cyanColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    @weakify(self);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(240, 40));
        make.center.equalTo(self.view);
    }];
    
    RAC(label, text) = [[[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] startWith:[NSDate date]] map:^id (NSDate *value) {
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:value];
        return [NSString stringWithFormat:@"%ld时%ld分%ld秒", (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    }];
    
//    RAC(label, text) = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] map:^id _Nullable(NSDate * _Nullable value) {
//        return value.description;
//    }];
}

/**
 *  用UISlider实现调色板
 */
- (void)demo5 {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    
    UISlider *slider1 = [[UISlider alloc] init];
    [self.view addSubview:slider1];
    
    UISlider *slider2 = [[UISlider alloc] init];
    [self.view addSubview:slider2];
    
    UISlider *slider3 = [[UISlider alloc] init];
    [self.view addSubview:slider3];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 200));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];
    
    [slider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom).offset(20);
        make.width.mas_equalTo(300);
    }];
    
    [slider2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(slider1.mas_bottom).offset(20);
        make.width.mas_equalTo(300);
    }];
    
    [slider3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(slider2.mas_bottom).offset(20);
        make.width.mas_equalTo(300);
    }];
    
//    RACSignal *s1 = [[[slider1 rac_signalForControlEvents:UIControlEventValueChanged] map:^id(UISlider *slider) {
//        return @(slider.value);
//    }] startWith:@0];
    RACSignal *s1 = [[slider1 rac_newValueChannelWithNilValue:nil] startWith:@0];
    RACSignal *s2 = [[slider2 rac_newValueChannelWithNilValue:nil] startWith:@0];
    RACSignal *s3 = [[slider3 rac_newValueChannelWithNilValue:nil] startWith:@0];
    RACSignal *threeSignal = [RACSignal combineLatest:@[s1, s2, s3] reduce:^id _Nullable(NSNumber *value1, NSNumber *value2, NSNumber *value3){
        return @[value1, value2, value3];
    }];
    
    [threeSignal subscribeNext:^(id  _Nullable x) {
        NSArray *arr = x;
        topView.backgroundColor = [UIColor colorWithRed:[arr[0] doubleValue] green:[arr[1] doubleValue] blue:[arr[2] doubleValue] alpha:1];
    }];
}

/**
 *  map映射替换，filter判断，RAC()宏绑定，
 */
- (void)demo4 {
    UITextField * textField = ({
        UITextField * textField = [[UITextField alloc]init];
        textField.backgroundColor = [UIColor cyanColor];
        
        textField;
    });
    [self.view addSubview:textField];
    
    @weakify(self); //  __weak __typeof__(self) self_weak_ = self;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);    // __strong __typeof__(self) self = self_weak_;
        make.size.mas_equalTo(CGSizeMake(180, 40));
        make.center.equalTo(self.view);
    }];
    
    [[textField.rac_textSignal map:^id(NSString *text) {
        
        NSLog(@"%@", text);
        
        return @(text.length);
        
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[textField.rac_textSignal filter:^BOOL(NSString *text) {
        
        return text.length > 3;
        
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(180, 40));
        make.center.equalTo(self.view);
    }];
    
    RAC(button, backgroundColor) = [RACObserve(button, selected) map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ? [UIColor redColor] : [UIColor greenColor];
    }];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.selected = !x.selected;
    }];
    
}

/**
 *  创建、发送、销毁信号
 */
- (void)demo3 {
    RACSignal *signal = [self loginSignal];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    } completed:^{
        
    }];
}

- (RACSignal *)loginSignal
{
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        
        RACDisposable * schedulerDisposable = [[RACScheduler mainThreadScheduler]afterDelay:2 schedule:^{
            
            if (arc4random()%10 > 1) {
                
                [subscriber sendNext:@"Login response"];
                [subscriber sendCompleted];
            }
            else {
                
                [subscriber sendError:[NSError errorWithDomain:@"LOGIN_ERROR_DOMAIN" code:444 userInfo:@{}]];
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [schedulerDisposable dispose];
        }];
    }];
}

/**
 *  KVO
 */
- (void)demo2 {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    UIView *scrollViewContentView = [[UIView alloc] init];
    scrollViewContentView.backgroundColor = [UIColor yellowColor];
    [scrollView addSubview:scrollViewContentView];
    
    @weakify(self);
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(80, 80, 80, 80));
    }];
    
    [scrollViewContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)));
    }];
    
    [RACObserve(scrollView, contentOffset) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
}

/**
 *  事件监听、通知中心、延时、定时器、代理
 */
- (void)demo1 {
    UITextField *textField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.backgroundColor = [UIColor cyanColor];
        textField;
    });
    
    [self.view addSubview:textField];
    
    @weakify(self);
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(180, 40));
        make.center.equalTo(self.view);
    }];
    
    [[textField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSLog(@"%@", x);
    }];
    [self.view addGestureRecognizer:tap];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        NSLog(@"延时2秒");
    }];
    
    [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"间隔1秒");
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RAX" message:@"delegate" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"confirm", nil];
    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@, %@, %@", x.first, x.second, x.third);
    }];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
