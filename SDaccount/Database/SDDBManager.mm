//
//  SDDBManager.m
//  SDaccount
//
//  Created by SunLi on 2019/9/28.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDDBManager.h"
#import <WCDB/WCDB.h>

@interface SDDBManager ()
-(instancetype)initManager;
@end

@implementation SDDBManager
+(instancetype)sharedManager{
    static SDDBManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SDDBManager alloc]initManager];
    });
    return manager;
}

-(instancetype)initManager{
        self = [super init];
        if (self) {
            _database = [[WCTDatabase alloc]initWithPath:self.path];
            if (![_database canOpen]) {
                DDLogError(@"[DBManager]: can not open database!");
            }
        }
        return self;
}

-(NSString *)path{
    return [SDApplication.documentsPath stringByAppendingPathComponent:@"database/sd.db"];
}
@end
