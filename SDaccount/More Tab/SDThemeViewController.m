//
//  SDThemeViewController.m
//  SDaccount
//
//  Created by SunLi on 2019/10/14.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDThemeViewController.h"
#import "SDThemeManager.h"
#import "SDThemeTableViewCell.h"

@interface SDThemeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *themeTable;
@property (nonatomic, weak) SDThemeTableViewCell *checkedCell;
@property (nonatomic, strong) NSArray *themeList;

@end

@implementation SDThemeViewController
- (void)didInitialized {
    [super didInitialized];
    self.title = @"主题";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.themeList = [SDThemeManager sharedManager].themeList;
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.themeTable];
    [self.themeTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDThemeTableViewCell *cell = [[SDThemeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    id<SDThemeProtocol> theme = self.themeList[indexPath.row];
    [cell bindTheme:theme];

    if (theme == [SDThemeManager sharedManager].currentTheme) {
        [cell setChecked:YES animated:NO];
        self.checkedCell = cell;
    } else {
        [cell setChecked:NO animated:NO];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SDThemeTableViewCell *cell = (SDThemeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell != self.checkedCell) {
        [cell setChecked:YES animated:YES];
        [self.checkedCell setChecked:NO animated:NO];
        self.checkedCell = cell;

        id<SDThemeProtocol> theme = self.themeList[indexPath.row];
        [SDThemeManager sharedManager].currentTheme = theme;
    }
}

#pragma mark -
#pragma mark private property
- (UITableView *)themeTable {
    if (_themeTable == nil) {
        _themeTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _themeTable.delegate = self;
        _themeTable.dataSource = self;
        _themeTable.backgroundColor = UIColorClear;
        _themeTable.backgroundView.backgroundColor = UIColorClear;
        _themeTable.rowHeight = K_ThemeCellHeight;
        _themeTable.tableFooterView = [UIView new];
        _themeTable.separatorStyle = UITableViewScrollPositionNone;
        _themeTable.showsVerticalScrollIndicator = NO;
    }
    return _themeTable;
}

@end
