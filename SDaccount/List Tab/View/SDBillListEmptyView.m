//
//  SDBillListEmptyView.m
//  SDaccount
//
//  Created by SunLi on 2020/2/19.
//  Copyright © 2020 PacmanSun. All rights reserved.
//

#import "SDBillListEmptyView.h"

@interface SDBillListEmptyView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SDBillListEmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorClear;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(self);
            make.height.mas_equalTo(50);
            make.centerY.mas_equalTo(self).mas_offset(-30);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = UIFontMake(17.0f);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = UIColorMakeWithHex(@"#757575");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"暂无条目，点击 “+” 添加项目";
    }
    return _titleLabel;
}

@end
