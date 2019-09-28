//
//  SDWebViewController.m
//  SDaccount
//
//  Created by SunLi on 2019/9/10.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface SDWebViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation SDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.requestUrlString) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrlString]];
        [self.webView loadRequest:request];
    } else if (self.htmlString) {
        [self.webView loadHTMLString:self.htmlString baseURL:self.htmlBaseUrl];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initSubviews {
    [super initSubviews];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    WKUserContentController *controller = [[WKUserContentController alloc]init];
    configuration.userContentController = controller;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    self.webView.allowsBackForwardNavigationGestures = YES;  //允许滑动手势
    if (@available(iOS 9.0, *)) {
        self.webView.allowsLinkPreview = YES;
    }
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];

    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:@"webView"];

    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight + StatusBarHeight, SCREEN_WIDTH, 15)];
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
    self.progressView.trackTintColor = UIColorClear;
    self.progressView.progressTintColor = UIColorBlue;
    [self.view addSubview:self.progressView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"webView") {
        if (SDIsEqualString(keyPath, @"estimatedProgress")) {
            SDLog(@"loading  --  %.2f", self.webView.estimatedProgress);
            self.progressView.progress = self.webView.estimatedProgress;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    SDLog(@"finish load");
    self.progressView.progress = 0;
    @weakify(self)
    [webView evaluateJavaScript: @"document.title" completionHandler:^(NSString *_Nullable string, NSError *_Nullable error) {
        @strongify(self)
        self.title = string;
    }];
    self.navigationController.interactivePopGestureRecognizer.enabled = !webView.canGoBack;
}

@end
