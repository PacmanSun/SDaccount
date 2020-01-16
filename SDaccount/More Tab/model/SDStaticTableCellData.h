//
//  SDStaticTableCellData.h
//  SDaccount
//
//  Created by SunLi on 2019/10/26.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger, SDStaticTableViewCellAccessoryType) {
    SDStaticTableViewCellAccessoryTypeNone,
    SDStaticTableViewCellAccessoryTypeDisclosureIndicator,
    SDStaticTableViewCellAccessoryTypeDetailDisclosureButton,
    SDStaticTableViewCellAccessoryTypeCheckmark,
    SDStaticTableViewCellAccessoryTypeDetailButton,
    SDStaticTableViewCellAccessoryTypeSwitch,
};
@interface SDStaticTableCellData : NSObject

/// 当前 cellData 的标志，一般同个 tableView 里的每个 cellData 都会拥有不相同的 identifier
@property (nonatomic, strong) NSString *identifier;

/// 当前 cellData 所对应的 indexPath
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;

/// init cell 时要使用的 style
@property (nonatomic, assign) UITableViewCellStyle style;

/// cell 的高度，默认为 TableViewCellNormalHeight
@property (nonatomic, assign) CGFloat height;

/// cell 左边要显示的图片，将会被设置到 cell.imageView.image
@property (nonatomic, strong) UIImage *image;

/// cell 的文字，将会被设置到 cell.textLabel.text
@property (nonatomic, copy) NSString *text;

/// cell 的详细文字，将会被设置到 cell.detailTextLabel.text，所以要求 cellData.style 的值必须是带 detailTextLabel 类型的 style
@property (nonatomic, copy, nullable) NSString *detailText;

/// cell 被点击时接受事件的对象及回调方法
@property (nonatomic, weak) id selectedTarget;
@property (nonatomic, assign) SEL selectedAction;

/// cell 右边的 accessoryView 的类型
@property (nonatomic, assign) SDStaticTableViewCellAccessoryType accessoryType;

/// 配合 accessoryType 使用，不同的 accessoryType 需要配合不同 class 的 accessoryValue 使用。例如 SDStaticTableViewCellAccessoryTypeSwitch 要求传 @YES 或 @NO 用于控制 UISwitch.on 属性。
@property (nonatomic, strong, nullable) id accessoryValue;

/// 当 accessoryType 是某些带 UIControl 的控件时，可通过这两个属性来为 accessoryView 添加操作事件。
/// 目前支持的类型包括：SDStaticTableViewCellAccessoryTypeDetailDisclosureButton、SDStaticTableViewCellAccessoryTypeDetailButton、SDStaticTableViewCellAccessoryTypeSwitch
/// @warning 这个 selector 接收一个参数，与 didSelectAction 一样，这个参数一般情况下也是当前的 QMUIStaticTableViewCellData 对象，仅在 Switch 时会传 UISwitch 控件的实例
@property (nonatomic, weak) id accessoryTarget;
@property (nonatomic, assign, nullable) SEL accessoryAction;

+ (instancetype)staticTableViewCellDataWithIdentifier:(NSString *)identifier
                                                image:(UIImage *)image
                                                 text:(NSString *)text
                                           detailText:(nullable NSString *)detailText
                                        accessoryType:(SDStaticTableViewCellAccessoryType)accessoryType;

+ (instancetype)staticTableViewCellDataWithIdentifier:(NSString *)identifier
                                                style:(UITableViewCellStyle)style
                                               height:(CGFloat)height
                                                image:(UIImage *)image
                                                 text:(NSString *)text
                                           detailText:(nullable NSString *)detailText
                                        accessoryType:(SDStaticTableViewCellAccessoryType)accessoryType
                                 accessoryValueObject:(nullable id)accessoryValueObject
                                      accessoryTarget:(nullable id)accessoryTarget
                                      accessoryAction:(nullable SEL)accessoryAction;

+ (UITableViewCellAccessoryType)tableViewCellAccessoryTypeWithStaticAccessoryType:(SDStaticTableViewCellAccessoryType)type;
- (void)addSelectedTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
