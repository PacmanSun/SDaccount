//
//  SDStaticTableSectionData.m
//  SDaccount
//
//  Created by SunLi on 2019/10/26.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDStaticTableSectionData.h"

@implementation SDStaticTableSectionData
- (instancetype)initWithTitle:(nullable NSString *)title staticCellDataList:(NSArray<SDStaticTableCellData *> *)cellDataList {
    self = [super init];
    if (self) {
        _title = title;
        _headerHeight = 20;
        _footerHeight = 0.01;
        _cellStaticDataList = cellDataList;
    }
    return self;
}

@end
