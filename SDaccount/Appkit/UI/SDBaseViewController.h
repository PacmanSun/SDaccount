//
//  SDBaseViewController.h
//  SDaccount
//
//  Created by SunLi on 2019/9/9.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDBaseViewController : QMUICommonViewController

// pop
- (void)back;
// 解决 content scroll 和返回手势冲突
- (void)registerConflictGestureScroll:(UIScrollView *)scroll;

@end

NS_ASSUME_NONNULL_END
