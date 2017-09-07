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
 *  报时demo
 */
- (void)demo6 {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:label];
    
    @weakify(self);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(240, 40));
        make.center.equalTo(self.view);
    }];
    
    RAC(label, text) = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] map:^id _Nullable(NSDate * _Nullable value) {
        return value.description;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
