//
//  SDStaticTableSectionData.h
//  SDaccount
//
//  Created by SunLi on 2019/10/26.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SDStaticTableCellData;
@interface SDStaticTableSectionData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, strong) NSArray<SDStaticTableCellData *> *cellStaticDataList;
@property (nonatomic, strong) id accessoryObject;

- (instancetype)initWithTitle:(nullable NSString *)title staticCellDataList:(NSArray<SDStaticTableCellData *> *)cellDataList;

@end

NS_ASSUME_NONNULL_END
