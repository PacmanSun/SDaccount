//
//  UITableViewCell+SDStaticDataBinding.m
//  SDaccount
//
//  Created by SunLi on 2019/10/26.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "UITableViewCell+SDStaticDataBinding.h"

@implementation UITableViewCell (SDStaticDataBinding)
- (void)sd_bindStaticData:(SDStaticTableCellData *)staticCellData {
    self.imageView.image = staticCellData.image;
    self.textLabel.text = staticCellData.text;
    self.detailTextLabel.text = staticCellData.detailText;
    self.accessoryType = [SDStaticTableCellData tableViewCellAccessoryTypeWithStaticAccessoryType:staticCellData.accessoryType];

    if (staticCellData.accessoryType == SDStaticTableViewCellAccessoryTypeSwitch) {
        UISwitch *switcher;
        BOOL switcherOn = NO;

        if ([self.accessoryView isKindOfClass:UISwitch.class]) {
            switcher = (UISwitch *)self.accessoryView;
        } else {
            switcher = [[UISwitch alloc]init];
        }

        if ([staticCellData.accessoryValue isKindOfClass:NSNumber.class]) {
            switcherOn = [((NSNumber *)staticCellData.accessoryValue) boolValue];
        }

        switcher.onTintColor = UIColorMakeWithHex(SD_THEME_COLOR);
        switcher.tintColor = switcher.onTintColor;
        switcher.on = switcherOn;
        [switcher removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [switcher  addTarget:staticCellData.selectedTarget
                      action:staticCellData.accessoryAction
            forControlEvents:UIControlEventValueChanged];
        self.accessoryView = switcher;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
