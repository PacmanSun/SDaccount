//
//  SDCategoryService.m
//  SDaccount
//
//  Created by SunLi on 2019/9/29.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDCategoryService.h"
#import "SDDBManager.h"
#import "SDCategory+WCTTableCoding.h"

static NSString *const keyCategoryVersion = @"category_version";

@interface SDCategoryService ()

@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) WCTDatabase *db;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableDictionary *map;

- (void)insertAllWithPlistDict:(NSDictionary *)dict;
- (void)setupCategories;
- (BOOL)isBetaVersion:(NSString *)version;
@end

@implementation SDCategoryService

+ (instancetype)service {
    static SDCategoryService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SDCategoryService alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _list = [NSMutableArray arrayWithCapacity:15];
        _map = [NSMutableDictionary dictionaryWithCapacity:50];

        _db = DBManager.database;
        [_db createTableAndIndexesOfName:self.tableName withClass:[SDCategory class]];
    }
    return self;
}

- (SDCategory *)queryCategoryWithName:(NSString *)categoryName {
    NSParameterAssert(categoryName);
    NSString *key = [NSString stringWithFormat:@"%@", categoryName];
    return self.map[key];
}

- (void)addCustomCategoryWithName:(NSString *)categoryName {
    SDCategory *newCate = [[SDCategory alloc]init];
    newCate.isAutoIncrement = YES;
    newCate.name = categoryName;
    newCate.iconName = @"sd_custom";
    newCate.builtin = NO;
    newCate.color = SD_THEME_COLOR;
    NSInteger maxIndex = [[self.db getOneValueOnResult:SDCategory.sortIndex.max() fromTable:self.tableName]integerValue];
    newCate.sortIndex = maxIndex + 1;
    [self.db insertObject:newCate into:self.tableName];

    [self.list addObject:newCate];
    NSString *key = [NSString stringWithFormat:@"_%@", newCate.name];
    self.map[key] = newCate;
}

- (NSArray<SDCategory *> *)fetchCustomCategory {
    NSArray *res;
    res = [self.db getObjectsOfClass:SDCategory.class fromTable:self.tableName where:SDCategory.builtin == NO];
    return res;
}

#pragma mark -
#pragma mark private method
- (void)insertAllWithPlistDict:(NSDictionary *)dict {
    NSArray *list = dict[@"list"];
    [list enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *_Nonnull stop) {
        SDCategory *cate = [SDCategory yy_modelWithDictionary:dict];
        cate.isAutoIncrement = YES;
        if (cate) {
            [self.list addObject:cate];
        }
    }];
    [self.db insertObjects:self.list into:self.tableName];
}

- (void)setupCategories {
    BOOL haveCache = [[self.db getOneValueOnResult:SDCategory.categoryID.count() fromTable:self.tableName]unsignedIntegerValue] > 0;
    NSString *plistFile = [[NSBundle mainBundle]pathForResource:@"Categories" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistFile];
    NSString *version = dict[@"version"];
    NSString *orderVersion = [KeyValueStore stringForKey:keyCategoryVersion];

    if (!haveCache) {
        [self insertAllWithPlistDict:dict];
        DDLogInfo(@"[Category Service]: insert category data");
    } else if (!SDIsEqualString(version, orderVersion)) {
        DDLogInfo(@"[Category Service]: update category data");
        if ([self isBetaVersion:orderVersion]) {
            [self.db deleteAllObjectsFromTable:self.tableName];
            [self insertAllWithPlistDict:dict];
        }
    } else {
        WCTSelect *select = [self.db prepareSelectObjectsOfClass:SDCategory.class fromTable:self.tableName];
        NSArray *res = select.allObjects;
        [self.list addObjectsFromArray:res];
        DDLogInfo(@"[Category Service]: load category data from cache");
    }
    [KeyValueStore setString:version forKey:keyCategoryVersion];

    [self.list enumerateObjectsUsingBlock:^(SDCategory *categroy, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *key = [NSString stringWithFormat:@"_%@", categroy.name];
        self.map[key] = categroy;
    }];
}

- (BOOL)isBetaVersion:(NSString *)version {
    float v = [version floatValue];
    return v < 1.0;
}

@end
