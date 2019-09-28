//
//  SDTimeCenter.h
//  SDaccount
//
//  Created by SunLi on 2019/9/28.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TimeCenter [SDTimeCenter center]

typedef void (^TimeHandler)(NSInteger newYear, NSInteger newmonth, BOOL haveNext);

NS_ASSUME_NONNULL_BEGIN

@interface SDTimeCenter : NSObject

@property (nonatomic, assign, readonly) NSInteger sdYear;
@property (nonatomic, assign, readonly) NSInteger sdMonth;

@property (nonatomic, assign, readonly) NSInteger nowYear;
@property (nonatomic, assign, readonly) NSInteger nowMonth;

+ (instancetype)center;

- (void)getCurrentTime:(TimeHandler)timeHandler;
- (void)moveNext:(TimeHandler)nextHandler;
- (void)movePrev:(TimeHandler)prevHandler;

@end

NS_ASSUME_NONNULL_END
