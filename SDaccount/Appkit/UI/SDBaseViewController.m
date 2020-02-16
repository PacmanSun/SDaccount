//
//  SDBaseViewController.m
//  SDaccount
//
//  Created by SunLi on 2019/9/9.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDBaseViewController.h"
#import <UMMobClick/MobClick.h>

@interface SDBaseViewController ()

@end

@implementation SDBaseViewController

-(void)didInitialized {
    [super didInitialized];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorMakeWithHex(SD_BG_GRAY);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass(self.class)];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerConflictGestureScroll:(UIScrollView *)scroll {
    [scroll.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configPopGesture {
    //这个可能导致乱栈。
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    /**
     * 乱栈处理
     if (count > 2 && self.navigationItem.leftBarButtonItem != nil) {
     // 连续隐藏导航栏时，连续手势返回会造成栈乱，因此禁止后一个手势返回。
     // 但在iOS10上，应该没有这个问题了，所以对iOS10以上放开限制，允许手势返回
     MKBaseViewController *previousViewController = self.navigationController.viewControllers[count - 2];
     if ([previousViewController isKindOfClass:[MKBaseViewController class]]) {
     self.navigationController.interactivePopGestureRecognizer.enabled = systemVersion >= 10.0;
     }
     else {
     self.navigationController.interactivePopGestureRecognizer.enabled = YES;
     }
     }
     else if (count > 1 && self.navigationItem.leftBarButtonItem != nil) {
     self.navigationController.interactivePopGestureRecognizer.enabled = YES;
     }
     else {
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
     }
     **/
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
