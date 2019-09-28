//
//  SDTimeCenter.m
//  SDaccount
//
//  Created by SunLi on 2019/9/28.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDTimeCenter.h"

@implementation SDTimeCenter

+ (instancetype)center {
    static SDTimeCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SDTimeCenter alloc]initCenter];
    });
    return instance;
}

- (instancetype)initCenter {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)getCurrentTime:(TimeHandler)timeHandler {
    if (timeHandler) {
        timeHandler(self.nowYear, self.nowMonth, NO);
    }
}

- (void)moveNext:(TimeHandler)nextHandler {
}

- (void)movePrev:(TimeHandler)prevHandler {
}

- (NSInteger)nowYear {
    NSDate *date = [NSDate date];
    return date.year;
}

- (NSInteger)nowMonth {
    NSDate *date = [NSDate date];
    return date.month;
}

@end
