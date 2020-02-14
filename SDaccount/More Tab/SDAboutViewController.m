//
//  SDAboutViewController.m
//  SDaccount
//
//  Created by SunLi on 2019/10/14.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDAboutViewController.h"
#import "SDWebViewController.h"

@interface SDAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation SDAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorMakeWithHex(SD_THEME_COLOR);
    self.title = @"关于";
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", SDApplication.appVersion];
    self.authorLabel.text = @"设计、产品、开发：\n\nPacmanSun";
    [self.authorLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAuthorAreaTapped:)]];
}

- (void)onAuthorAreaTapped:(id)sender {
    SDWebViewController *webVC=[[SDWebViewController alloc]init];
    webVC.requestUrlString=@"https://github.com/PacmanSun";
    [self.navigationController pushViewController:webVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
