//
//  SDTabBarItem.m
//  SDaccount
//
//  Created by SunLi on 2019/10/15.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDTabBarItem.h"

#define K_IMAGE_SIZE   23
#define K_LABEL_HEIGHT 16
#define K_IMAGE_TOP    6.33

@interface SDTabBarItem ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setupSubviews;

@end

@implementation SDTabBarItem

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage index:(NSInteger)index {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = UIColorClear;
        _title = title;
        _image = image;
        _selectedImage = selectedImage;
        _index = index;

        [self setupSubviews];

        self.titleLabel.text = title;
        self.iconView.image = image;

        @weakify(self)
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id _Nonnull sender) {
            @strongify(self)
            if (self.selectedCallback) {
                self.selectedCallback();
            }
        }];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)refreshThemeColor {
    if (self.selected) {
        if (self.title) {
            self.titleLabel.textColor = UIColorMakeWithHex(SD_THEME_COLOR);
        }
        self.iconView.image = self.selectedImage;
    }
}

#pragma mark -
#pragma mark private method

- (void)setupSubviews {
    if (self.title) {
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];

        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(K_IMAGE_TOP);
            make.centerX.mas_equalTo(self);
            make.width.and.height.mas_equalTo(K_IMAGE_SIZE);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(self);
            make.height.mas_equalTo(K_LABEL_HEIGHT);
        }];
    } else {
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.and.height.mas_equalTo(K_IMAGE_SIZE);
        }];
    }
}

#pragma mark -
#pragma mark property

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        if (self.title) {
            self.titleLabel.textColor = UIColorMakeWithHex(SD_THEME_COLOR);
        }
        self.iconView.image = self.selectedImage;
    } else {
        if (self.title) {
            self.titleLabel.textColor = UIColorMakeWithHex(@"#8a8a8a");
        }
        self.iconView.image = self.image;
    }
}

- (UIImage *)selectedImage {
    if (_selectedImage) {
        return _selectedImage;
    } else {
        return _image;
    }
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorMakeWithHex(@"8a8a8a");
        _titleLabel.font = UIFontMake(10.0f);
    }
    return _titleLabel;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc]init];
        _iconView.userInteractionEnabled = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
