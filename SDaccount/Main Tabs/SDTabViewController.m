//
//  SDTabViewController.m
//  SDaccount
//
//  Created by SunLi on 2019/10/15.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDTabViewController.h"
#import "SDTabBarItem.h"
#import "SDListViewController.h"
#import "SDCategoryViewController.h"
#import "SDAddItemPresenter.h"
#import "SDReportViewController.h"
#import "SDMoreViewController.h"

#if DEBUG
#import "FLEXManager.h"
#endif

#define TAB_ICON_NAMES @[@"list", @"category", @"report", @"more", @"add"]
static NSString *tabIconPrefix = @"icon_tabbar_";
static NSString *tabIconSuffix = @"_sel";

@interface SDTabViewController ()

@property (nonatomic, strong) UIView *customTabBar;
@property (nonatomic, strong) NSArray *itemList;
@property (nonatomic, strong) SDTabBarItem *selectedItem;
@property (nonatomic, strong) SDTabBarItem *addItem;

+ (NSArray *)tabbarItemNames;
+ (NSArray *)tabbarSelectedItemNames;
- (void)onThemeChanged:(NSNotification *)notification;
@end

@implementation SDTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customTabBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TabBarHeight)];
    [self.tabBar addSubview:self.customTabBar];
    NSLog(@"%@", SDTabViewController.tabbarItemNames[1]);
//    SDTabBarItem *listItem = [[SDTabBarItem alloc]initWithTitle:@"总览" image:UIImageMake(@"icon_tabbar_list") selectedImage:SDThemeImageMake(@"icon_tabbar_list_sel") index:0];
//    SDTabBarItem *categoryItem = [[SDTabBarItem alloc]initWithTitle:@"分类" image:UIImageMake(@"icon_tabbar_category") selectedImage:SDThemeImageMake(@"icon_tabbar_category_sel") index:1];
//    SDTabBarItem *reportItem = [[SDTabBarItem alloc]initWithTitle:@"报表" image:UIImageMake(@"icon_tabbar_report") selectedImage:SDThemeImageMake(@"icon_tabbar_report_sel") index:2];
//    SDTabBarItem *moreItem = [[SDTabBarItem alloc]initWithTitle:@"更多" image:UIImageMake(@"icon_tabbar_more") selectedImage:SDThemeImageMake(@"icon_tabbar_more_sel") index:3];
//    SDTabBarItem *addItem = [[SDTabBarItem alloc]initWithTitle:nil image:UIImageMake(@"icon_tabbar_add") selectedImage:nil index:4];
    SDTabBarItem *listItem = [[SDTabBarItem alloc]initWithTitle:@"总览" image:UIImageMake(SDTabViewController.tabbarItemNames[0]) selectedImage:SDThemeImageMake(SDTabViewController.tabbarSelectedItemNames[0]) index:0];
    SDTabBarItem *categoryItem = [[SDTabBarItem alloc]initWithTitle:@"分类" image:UIImageMake(SDTabViewController.tabbarItemNames[1]) selectedImage:SDThemeImageMake(SDTabViewController.tabbarSelectedItemNames[1]) index:1];
    SDTabBarItem *reportItem = [[SDTabBarItem alloc]initWithTitle:@"报表" image:UIImageMake(SDTabViewController.tabbarItemNames[2]) selectedImage:SDThemeImageMake(SDTabViewController.tabbarSelectedItemNames[2]) index:2];
    SDTabBarItem *moreItem = [[SDTabBarItem alloc]initWithTitle:@"更多" image:UIImageMake(SDTabViewController.tabbarItemNames[3]) selectedImage:SDThemeImageMake(SDTabViewController.tabbarSelectedItemNames[3]) index:3];
    SDTabBarItem *addItem = [[SDTabBarItem alloc]initWithTitle:nil image:UIImageMake(SDTabViewController.tabbarItemNames[4]) selectedImage:nil index:4];

    addItem.backgroundColor = UIColorMakeWithHex(SD_THEME_COLOR);
    addItem.layer.cornerRadius = 3;
    self.addItem = addItem;

    NSArray *layoutList = @[listItem, categoryItem, addItem, reportItem, moreItem];
    self.itemList = @[listItem, categoryItem, reportItem, moreItem];

    CGFloat itemW = SCREEN_WIDTH / layoutList.count;

    [layoutList enumerateObjectsUsingBlock:^(SDTabBarItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.customTabBar addSubview:obj];
        if (obj.index != 4) {
            obj.frame = CGRectMake(idx * itemW, 1, itemW, TabBarHeight - 1);

            @weakify(self)
            @weakify(obj)
            [obj setSelectedCallback:^{
                @strongify(self)
                @strongify(obj)
                self.selectedIndex = obj.index;
            }];
        } else {
            CGFloat addW = 42;
            CGFloat marginH = (itemW - addW) / 2.0;
            CGFloat marginV = 7;
            obj.frame = CGRectMake(marginH + itemW * idx, marginV, addW, TabBarHeight - 2 * marginV);
            [obj setSelectedCallback:^{
//                SDAddItemPresenter
            }];
        }

        listItem.selected = YES;
        self.selectedItem = listItem;
    }];
}

- (void)didInitialized {
    [super didInitialized];

    SDListViewController *listVC = [[SDListViewController alloc]init];
    listVC.hidesBottomBarWhenPushed = NO;
    SDNaviController *listNavi = [[SDNaviController alloc]initWithRootViewController:listVC];

    SDCategoryViewController *categoryVC = [[SDCategoryViewController alloc]init];
    categoryVC.hidesBottomBarWhenPushed = NO;
    SDNaviController *categoryNavi = [[SDNaviController alloc]initWithRootViewController:categoryVC];

    SDReportViewController *reportVC = [[SDReportViewController alloc]init];
    reportVC.hidesBottomBarWhenPushed = NO;
    SDNaviController *reportNavi = [[SDNaviController alloc]initWithRootViewController:reportVC];

    SDMoreViewController *moreVC = [[SDMoreViewController alloc]init];
    moreVC.hidesBottomBarWhenPushed = NO;
    SDNaviController *moreNavi = [[SDNaviController alloc]initWithRootViewController:moreVC];

    self.viewControllers = @[listNavi, categoryNavi, reportNavi, moreNavi];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onThemeChanged:) name:SDThemeDidUpdateNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    for (UIView *view in self.tabBar.subviews) {
        if (view != self.customTabBar) {
            [view removeFromSuperview];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
#if DEBUG
    if (motion == UIEventSubtypeMotionShake) {
        FLEXManager *manger = [FLEXManager sharedManager];
        if (manger.isHidden) {
            [manger showExplorer];
        } else {
            [manger hideExplorer];
        }
    }
#endif
}

#pragma mark -
#pragma mark private method

+ (NSArray *)tabbarItemNames {
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:5];
    [TAB_ICON_NAMES enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *str = [[NSString alloc]initWithFormat:@"%@%@", tabIconPrefix, obj];
        [arr addObject:str];
    }];
    return arr.copy;
}

+ (NSArray *)tabbarSelectedItemNames {
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:5];
    [SDTabViewController.tabbarItemNames enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx != 4) {
            NSString *str = [[NSString alloc]initWithFormat:@"%@%@", obj, tabIconSuffix];
            [arr addObject:str];
        }
    }];
    return arr.copy;
}

- (void)onThemeChanged:(NSNotification *)notification {
}

#pragma mark -
#pragma mark property

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    SDTabBarItem *item = self.itemList[selectedIndex];
    if (self.selectedItem == item) {
        return;
    }
    [super setSelectedIndex:selectedIndex];
    self.selectedItem.selected = NO;
    item.selected = YES;
    self.selectedItem = item;
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
