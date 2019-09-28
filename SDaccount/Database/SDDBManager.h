//
//  SDDBManager.h
//  SDaccount
//
//  Created by SunLi on 2019/9/28.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

#define DBManager [SDDBManager manager]

NS_ASSUME_NONNULL_BEGIN

@interface SDDBManager : NSObject
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong) WCTDatabase *database;

+ (instancetype)manager;

@end

NS_ASSUME_NONNULL_END
