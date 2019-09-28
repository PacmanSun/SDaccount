//
//  SDWebViewController.h
//  SDaccount
//
//  Created by SunLi on 2019/9/10.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDWebViewController : SDBaseViewController
@property (nonatomic, strong) NSString *requestUrlString;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) NSURL *htmlBaseUrl;
@end

NS_ASSUME_NONNULL_END
