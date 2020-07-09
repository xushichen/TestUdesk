//
//  UdeskAgentMenuViewController.h
//  UdeskSDK
//
//  Created by Udesk on 16/3/16.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import "UdeskBaseViewController.h"

@interface UdeskAgentMenuViewController : UdeskBaseViewController

@property (nonatomic, copy) void(^didSelectAgentGroupServerBlock)(void);
@property (nonatomic, strong) NSArray *menuDataSource;

- (void)requestAgentMenu:(NSArray *)result;

@end
