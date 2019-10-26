//
//  SDTabBarItem.h
//  SDaccount
//
//  Created by SunLi on 2019/10/15.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDTabBarItem : UIView

@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, copy) dispatch_block_t selectedCallback;

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage index:(NSInteger)index;
- (void)refreshThemeColor;

@end

NS_ASSUME_NONNULL_END
