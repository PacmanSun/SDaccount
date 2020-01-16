//
//  SDStaticTableCellData.m
//  SDaccount
//
//  Created by SunLi on 2019/10/26.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDStaticTableCellData.h"

@implementation SDStaticTableCellData

+ (instancetype)staticTableViewCellDataWithIdentifier:(NSString *)identifier
                                                style:(UITableViewCellStyle)style
                                               height:(CGFloat)height
                                                image:(UIImage *)image
                                                 text:(NSString *)text
                                           detailText:(nullable NSString *)detailText
                                        accessoryType:(SDStaticTableViewCellAccessoryType)accessoryType accessoryValueObject:(id)accessoryValueObject
                                      accessoryTarget:(id)accessoryTarget
                                      accessoryAction:(SEL)accessoryAction
{
    SDStaticTableCellData *data = [[SDStaticTableCellData alloc]init];
    data.identifier = [NSString stringWithFormat:@"SDStaticTableCellIdentifier_%@", identifier];
    data.style = style;
    data.height = height;
    data.image = image;
    data.text = text;
    data.detailText = detailText;
    data.accessoryType = accessoryType;
    data.accessoryValue = accessoryValueObject;
    data.accessoryTarget = accessoryTarget;
    data.accessoryAction = accessoryAction;
    return data;
}

+ (instancetype)staticTableViewCellDataWithIdentifier:(NSString *)identifier
                                                image:(UIImage *)image
                                                 text:(NSString *)text
                                           detailText:(nullable NSString *)detailText
                                        accessoryType:(SDStaticTableViewCellAccessoryType)accessoryType
{
    return [self staticTableViewCellDataWithIdentifier:identifier
                                                 style:(detailText ? UITableViewCellStyleSubtitle : UITableViewCellStyleDefault)
                                                height:50
                                                 image:image
                                                  text:text
                                            detailText:detailText
                                         accessoryType:accessoryType
                                  accessoryValueObject:nil
                                       accessoryTarget:nil
                                       accessoryAction:NULL];
}

- (void)addSelectedTarget:(id)target
                   action:(SEL)action
{
    self.selectedTarget = target;
    self.selectedAction = action;
}

+ (UITableViewCellAccessoryType)tableViewCellAccessoryTypeWithStaticAccessoryType:(SDStaticTableViewCellAccessoryType)type
{
    switch (type) {
        case SDStaticTableViewCellAccessoryTypeDisclosureIndicator:
            return UITableViewCellAccessoryDisclosureIndicator;
        case SDStaticTableViewCellAccessoryTypeDetailDisclosureButton:
            return UITableViewCellAccessoryDetailDisclosureButton;
        case SDStaticTableViewCellAccessoryTypeCheckmark:
            return UITableViewCellAccessoryCheckmark;
        case SDStaticTableViewCellAccessoryTypeDetailButton:
            return UITableViewCellAccessoryDetailButton;
        case SDStaticTableViewCellAccessoryTypeSwitch:
        default:
            return UITableViewCellAccessoryNone;
    }
}

@end
