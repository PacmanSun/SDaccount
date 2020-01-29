//
//  SDThemeCellTableViewCell.m
//  SDaccount
//
//  Created by SunLi on 2019/10/26.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDThemeTableViewCell.h"
#import <BEMCheckBox/BEMCheckBox.h>

#define K_Inset            15
#define K_Space            35
#define K_ScreenShotWidth  150
#define K_ScreenShotHeight 300
#define K_ShotCount        2

@interface SDThemeTableViewCell ()

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *imageContent;
@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) NSArray<UIImageView *> *imageViewList;

@end

@implementation SDThemeTableViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (instancetype)initForTableView:(UITableView *)tableView withStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initForTableView:tableView withStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorWhite;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)bindTheme:(id<SDThemeProtocol>)theme {
    self.titleLabel.text = [theme themeName];
    UIColor *themeColor = UIColorMakeWithHex([theme themeName]);
    self.checkBox.onFillColor = themeColor;
    self.checkBox.onTintColor = themeColor;
    self.colorView.backgroundColor = themeColor;

    [self.imageViewList enumerateObjectsUsingBlock:^(UIImageView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (theme.themeScreenShots.count) {
            NSString *imageName = [theme themeScreenShots][idx];
            obj.image = UIImageMake(imageName);
        }
    }];
}

- (void)setChecked:(BOOL)checked animated:(BOOL)animated {
    [_checkBox setOn:checked animated:animated];
}

#pragma mark -
#pragma mark private method
- (void)setupSubviews {
    [self.contentView addSubview:self.colorView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imageContent];
    [self.contentView addSubview:self.checkBox];
    [self.contentView addSubview:self.sepLine];

    self.colorView.frame = CGRectMake(0, K_Inset, 4, 24);
    self.titleLabel.frame = CGRectMake(K_Inset, K_Inset, 120, 24);
    self.imageContent.frame = CGRectMake(0, self.titleLabel.bottom + K_Inset, SCREEN_WIDTH, K_ScreenShotHeight);
    self.checkBox.frame = CGRectMake(SCREEN_WIDTH - 22 - SD_MARGIN, K_Inset, 22, 22);
    self.sepLine.frame = CGRectMake(0, K_ThemeCellHeight - K_Inset, SCREEN_WIDTH, K_Inset);

    CGFloat right = 0.0;
    NSMutableArray *imageViewList = [NSMutableArray arrayWithCapacity:K_ShotCount];
    for (int i = 0; i < K_ShotCount; i++) {
        CGRect imageViewRect = CGRectMake(K_Inset + i * K_ScreenShotWidth + i * K_Space, 0, K_ScreenShotWidth, K_ScreenShotHeight);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageViewRect];
        [self.imageContent addSubview:imageView];
        [imageViewList addObject:imageView];
        right = imageView.right + K_Space;
    }
    self.imageViewList = imageViewList.copy;
    self.imageContent.contentSize = CGSizeMake(right, 0.0);
}

#pragma mark -
#pragma mark property
- (UIView *)colorView {
    if (_colorView == nil) {
        _colorView = [[UIView alloc]init];
        _colorView.layer.cornerRadius = 1;
    }
    return _colorView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFont:UIFontMake(16.0f) textColor:UIColorMakeWithHex(SD_TEXT_COLOR_BLACK)];
    }
    return _titleLabel;
}

- (UIScrollView *)imageContent {
    if (_imageContent == nil) {
        _imageContent = [[UIScrollView alloc]init];
        _imageContent.showsHorizontalScrollIndicator = NO;
    }
    return _imageContent;
}

- (BEMCheckBox *)checkBox {
    if (_checkBox == nil) {
        _checkBox = [[BEMCheckBox alloc]init];
        _checkBox.lineWidth = 1;
        _checkBox.userInteractionEnabled = YES;
        _checkBox.onCheckColor = UIColorWhite;
    }
    return _checkBox;
}

- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = UIColorMakeWithHex(SD_BG_GRAY);
    }
    return _sepLine;
}

@end
