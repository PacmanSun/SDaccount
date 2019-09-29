//
//  SDCategory.h
//  SDaccount
//
//  Created by SunLi on 2019/9/29.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCategory : NSObject

@property (nonatomic,assign) NSInteger categoryID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *iconName;
@property (nonatomic,assign) BOOL builtin;
@property (nonatomic,assign) NSInteger sortIndex;
@property (nonatomic,strong) NSString *color;

@end

NS_ASSUME_NONNULL_END
