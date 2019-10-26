//
//  SDAppContext.m
//  SDaccount
//
//  Created by SunLi on 2019/10/22.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDAppContext.h"
#import <UMMobClick/MobClick.h>
#import "SDDBManager.h"
#import "SDCategoryService.h"
#import "SDLocationService.h"
#import "SDItemService.h"
static NSString *const keySD_AutoPresentPage = @"keySDAutoPresentPage";
@implementation SDAppContext
+ (instancetype)context {
    static SDAppContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[SDAppContext alloc]init];
    });
    return context;
}

- (void)startupflow {
//    setup log
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console

    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];

    DDLogDebug(@"%@", SDApplication.documentsPath);

#if DEBUG
    [MobClick setLogEnabled:YES];
#endif
    UMConfigInstance.appKey = @"5d891bed570df314e90007c5";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:[UIApplication sharedApplication].appVersion];

    [[SDThemeManager sharedManager]setup];

    [SDDBManager sharedManager];
    [SDCategoryService service];
    [SDLocationService service];
    [SDItemService service];

    DDLogInfo(@"[App context]: finish startup flow");
}

#pragma mark -
#pragma mark property
- (void)setAutoPresentAddItemTab:(BOOL)autoPresentAddItemTab {
    [KeyValueStore setBool: autoPresentAddItemTab forKey:keySD_AutoPresentPage];
}

- (BOOL)autoPresentAddItemTab {
    return [KeyValueStore boolForKey:keySD_AutoPresentPage defaultValue:NO];
}

@end
