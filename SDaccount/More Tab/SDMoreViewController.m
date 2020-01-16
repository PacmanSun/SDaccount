//
//  SDMoreViewController.m
//  SDaccount
//
//  Created by SunLi on 2019/10/14.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDMoreViewController.h"
#import "SDWebViewController.h"
#import "SDStaticTableCellData.h"
#import "SDStaticTableSectionData.h"
#import "UITableViewCell+SDStaticDataBinding.h"
#import "SDAboutViewController.h"
#import "SDThemeViewController.h"
#import "SDAddressService.h"
#import "SDRoomService.h"
#import "SDLocationService.h"
#import "UIViewController+KMNavigationBarTransition.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

static NSString *const kAppKey = @"27937485";
static NSString *const kAppSecret = @"eea7f866d202f318d0c4e00331db1c4f";

@interface SDMoreViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SDStaticTableSectionData *> *staticSections;
@property (nonatomic, strong) SDStaticTableCellData *addressCellData;
@property (nonatomic, strong) SDStaticTableCellData *roomCellData;
@property (nonatomic, strong) SDStaticTableCellData *locationCellData;
@property (nonatomic, strong) SDStaticTableCellData *autoPresentCellData;

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

- (void)onThemeChangde:(NSNotification *)notification;
- (void)loadStaticData;
- (void)onAddressCellSelected;
- (void)onRoomCellSelected;
- (void)onLocationCellSelected;
- (void)onSuggestCellSelected;
- (void)onScoreCellSelected;
- (void)onThemeCellSelected;
- (void)onLibCellSelected;
- (void)onAboutCellSelected;
- (void)onAutoPresentCellValueChanged:(UISwitch *)sender;
@end

@implementation SDMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadStaticData];
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)didInitialized {
    [super didInitialized];
    self.title = @"更多";
    [SDNotificationCenter addObserver:self selector:@selector(onThemeChangde:) name:SDThemeDidUpdateNotification object:nil];
}

- (void)dealloc {
    [SDNotificationCenter removeObserver:self];
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
#pragma mark private method

- (void)onThemeChangde:(NSNotification *)notification {
    UINavigationBar *bar = self.km_transitionNavigationBar;
    bar.barTintColor = [QMUICMI navBarBarTintColor];
    [bar setBackgroundImage:[QMUICMI navBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    bar.shadowImage = [QMUICMI navBarShadowImage];
    [self.tableView reloadData];
}

- (void)loadStaticData {
    SDStaticTableCellData *addCD = [SDStaticTableCellData staticTableViewCellDataWithIdentifier:@"address" image:UIImageMake(@"more_address") text:@"默认地址" detailText:[SDAddressService service].defaultAddress.name accessoryType:SDStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [addCD addSelectedTarget:self action:@selector(onAddressCellSelected)];
    self.addressCellData = addCD;

    SDStaticTableCellData *roomCD = [SDStaticTableCellData staticTableViewCellDataWithIdentifier:@"room" image:UIImageMake(@"more_room") text:@"默认房间" detailText:[SDAddressService service].defaultAddress.name accessoryType:SDStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [roomCD addSelectedTarget:self action:@selector(onRoomCellSelected)];
    self.roomCellData = roomCD;

    SDStaticTableCellData *locCD = [SDStaticTableCellData staticTableViewCellDataWithIdentifier:@"location" image:UIImageMake(@"more_loaction") text:@"默认位置" detailText:[SDAddressService service].defaultAddress.name accessoryType:SDStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [locCD addSelectedTarget:self action:@selector(onLocationCellSelected)];
    self.addressCellData = locCD;

    SDStaticTableCellData *themeCD = [SDStaticTableCellData staticTableViewCellDataWithIdentifier:@"theme" image:UIImageMake(@"more_theme") text:@"个性主题" detailText:nil accessoryType:SDStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [themeCD addSelectedTarget:self action:@selector(onThemeCellSelected)];

    SDStaticTableCellData *autoPresentCD = [SDStaticTableCellData staticTableViewCellDataWithIdentifier:@"autopresent" style:UITableViewCellStyleDefault height:50 image:UIImageMake(@"more_auto") text:@"启动时进入添加物品页面" detailText:nil accessoryType:SDStaticTableViewCellAccessoryTypeSwitch accessoryValueObject:@(AppContext.autoPresentAddItemTab) accessoryTarget:self accessoryAction:@selector(onAutoPresentCellValueChanged:)];
    self.autoPresentCellData = autoPresentCD;

    SDStaticTableCellData *suggestCD = [SDStaticTableCellData staticTableViewCellDataWithIdentifier:@"suggest" image:UIImageMake(@"more_suggest") text:@"意见反馈" detailText:nil accessoryType:SDStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [suggestCD addSelectedTarget:self action:@selector(onSuggestCellSelected)];

    SDStaticTableCellData *scoreCD = [SDStaticTableCellData staticTableViewCellDataWithIdentifier:@"score" image:UIImageMake(@"more_appstore") text:@"去 AppStore 评分" detailText:nil accessoryType:SDStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [scoreCD addSelectedTarget:self action:@selector(onScoreCellSelected)];

    SDStaticTableCellData *libCD = [SDStaticTableCellData staticTableViewCellDataWithIdentifier:@"lib" image:UIImageMake(@"more_library") text:@"开源库" detailText:nil accessoryType:SDStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [libCD addSelectedTarget:self action:@selector(onLibCellSelected)];

    SDStaticTableCellData *aboutCD = [SDStaticTableCellData staticTableViewCellDataWithIdentifier:@"about" image:UIImageMake(@"more_about") text:@"about" detailText:nil accessoryType:SDStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [aboutCD addSelectedTarget:self action:@selector(onAboutCellSelected)];

    SDStaticTableSectionData *sectionOne = [[SDStaticTableSectionData alloc]initWithTitle:nil staticCellDataList:@[themeCD, autoPresentCD]];
    sectionOne.headerHeight = SD_MARGIN;

    SDStaticTableSectionData *sectionTwo = [[SDStaticTableSectionData alloc]initWithTitle:nil staticCellDataList:@[suggestCD, scoreCD, libCD, aboutCD]];
    sectionTwo.headerHeight = SD_MARGIN;

    self.staticSections = @[sectionOne, sectionTwo];
    [self.tableView reloadData];
}

- (void)onAddressCellSelected {
    QMUIAlertController *actionSheet =
        [QMUIAlertController alertControllerWithTitle:@"选择一个地址"
                                              message:nil
                                       preferredStyle:QMUIAlertControllerStyleActionSheet];
    NSArray<SDAddress *> *list = [[SDAddressService service]addressList];
    [list enumerateObjectsUsingBlock:^(SDAddress *_Nonnull address, NSUInteger idx, BOOL *_Nonnull stop) {
        QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:address.name
                                                             style:QMUIAlertActionStyleDefault
                                                           handler:^(QMUIAlertAction *action) {
            [[SDAddressService service]configDefaultAddressWithName:address.name];
            self.addressCellData.detailText = address.name;
            [self.tableView reloadRow:0
                            inSection:0
                     withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [actionSheet addAction:action];
    }];
    [actionSheet addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
    [actionSheet showWithAnimated:YES];
}

- (void)onRoomCellSelected {
    QMUIAlertController *actionSheet =
        [QMUIAlertController alertControllerWithTitle:@"选择一个房间"
                                              message:nil
                                       preferredStyle:QMUIAlertControllerStyleActionSheet];
    NSString *addressKey = SDno2Str(SDAddressService.service.defaultAddress.addressID);
    NSArray<SDRoom *> *list = [[SDRoomService service]roomLists][addressKey];
    [list enumerateObjectsUsingBlock:^(SDRoom *_Nonnull room, NSUInteger idx, BOOL *_Nonnull stop) {
        QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:room.name
                                                             style:QMUIAlertActionStyleDefault
                                                           handler:^(QMUIAlertAction *action) {
            [[SDLocationService service]configDefaultLocationWithName:room.name
                                                               roomID:SDAddressService.service.defaultAddress.addressID];
            self.roomCellData.detailText = room.name;
            [self.tableView reloadRow:1
                            inSection:0
                     withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [actionSheet addAction:action];
    }];
    [actionSheet addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
    [actionSheet showWithAnimated:YES];
}

- (void)onLocationCellSelected {
    QMUIAlertController *actionSheet =
        [QMUIAlertController alertControllerWithTitle:@"选择一个位置"
                                              message:nil
                                       preferredStyle:QMUIAlertControllerStyleActionSheet];
    NSString *locationKey = SDno2Str(SDLocationService.service.defaultLocation.locationID);
    NSArray<SDLocation *> *list = [[SDLocationService service]locationLists][locationKey];
    [list enumerateObjectsUsingBlock:^(SDLocation *_Nonnull location, NSUInteger idx, BOOL *_Nonnull stop) {
        QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:location.name
                                                             style:QMUIAlertActionStyleDefault
                                                           handler:^(QMUIAlertAction *action) {
            [[SDLocationService service]configDefaultLocationWithName:location.name
                                                               roomID:SDRoomService.service.defaultRoom.roomID];
            self.locationCellData.detailText = location.name;
            [self.tableView reloadRow:2
                            inSection:0
                     withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [actionSheet addAction:action];
    }];
    [actionSheet addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
    [actionSheet showWithAnimated:YES];
}

- (void)onSuggestCellSelected {
    @weakify(self)
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController) {
            viewController.hidesBottomBarWhenPushed = YES;
            @strongify(self)
            [self.navigationController pushViewController: viewController animated:YES];
            [viewController setCloseBlock:^(YWFeedbackViewController *feedbackController) {
                [feedbackController.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)onScoreCellSelected {
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @""];
    [SDApplication openURL:[NSURL URLWithString:urlStr]];
}

- (void)onThemeCellSelected {
    SDThemeViewController *themeVC = [[SDThemeViewController alloc]init];
    [self.navigationController pushViewController:themeVC animated:YES];
}

- (void)onLibCellSelected {
    NSString *path = [[NSBundle mainBundle]bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"Library" ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];

    SDWebViewController *libVC = [[SDWebViewController alloc]init];
    libVC.htmlString = htmlCont;
    libVC.htmlBaseUrl = baseURL;
    [self.navigationController pushViewController:libVC animated:YES];
}

- (void)onAboutCellSelected {
    SDAboutViewController *aboutVC = [[SDAboutViewController alloc]init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)onAutoPresentCellValueChanged:(UISwitch *)sender {
    BOOL autoPresent = sender.isOn;
    self.autoPresentCellData.accessoryValue = @(autoPresent);
    AppContext.autoPresentAddItemTab = autoPresent;
}

#pragma mark -
#pragma mark property
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorClear;
        _tableView.backgroundView.backgroundColor = UIColorClear;
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001f)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = UIColorSeparator;
    }
    return _tableView;
}

- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
        _feedbackKit.defaultCloseButtonTitleFont = UIFontMake(0.0);
    }
    return _feedbackKit;
}

#pragma mark -
#pragma mark TableView

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SDStaticTableSectionData *sectionData = self.staticSections[indexPath.section];
    SDStaticTableCellData *cellData = sectionData.cellStaticDataList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellData.identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:cellData.style reuseIdentifier:cellData.identifier];
        cell.textLabel.textColor = UIColorMakeWithHex(SD_TEXT_COLOR_BLACK);
        cell.detailTextLabel.textColor = UIColorGray;
        cell.detailTextLabel.font = UIFontMake(13.0f);
    }
    [cell sd_bindStaticData:cellData];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SDStaticTableSectionData *sectionData = self.staticSections[section];
    return sectionData.cellStaticDataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.staticSections.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SDStaticTableSectionData *sectionData = self.staticSections[indexPath.section];
    SDStaticTableCellData *cellData = sectionData.cellStaticDataList[indexPath.row];
    if (cellData.selectedTarget && cellData.selectedAction) {
        [cellData.selectedTarget qmui_performSelector:cellData.selectedAction];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDStaticTableSectionData *sectionData = self.staticSections[indexPath.section];
    SDStaticTableCellData *cellData = sectionData.cellStaticDataList[indexPath.row];
    return cellData.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SDStaticTableSectionData *sectionData = self.staticSections[section];
    return sectionData.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SDStaticTableSectionData *sectionData = self.staticSections[section];
    return sectionData.footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

@end
