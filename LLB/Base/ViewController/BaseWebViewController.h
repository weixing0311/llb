//
//  BaseWebViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/8/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

//#import "JFABaseTableViewController.h"
#import <WebKit/WebKit.h>

typedef enum
{
    IS_HAVE_DG,//已购服务
    IS_TEAM_MANAGEMENT,//团队管理
}webUrlType;
@interface BaseWebViewController : BaseViewController
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic, copy ) NSString * urlStr;
@property (nonatomic, copy ) NSString * orderNo;
@property (nonatomic, copy ) NSString * payableAmount;
//订单类型 1 订货 2发货3.代购  4 充值  5积分订单 6 挖宝订单  7 押金支付
@property (nonatomic,assign) int payType;
///optType=0 充值，optType=1 支付  ，optType=3 积分支付      4 挖宝支付    5 押金支付
@property (nonatomic,assign) int opt;
@property (nonatomic,copy  ) NSString * rightBtnTitle;
@property (nonatomic,copy  ) NSString * rightBtnUrl;
@property (nonatomic,strong) UIProgressView * progressView;
/////0 订单来自商城 1 来自积分商城    2 挖宝订单  3 免费领取
@property (nonatomic,copy  ) NSString * integral;
@property (nonatomic,copy  ) NSString * wxPayCallBackUrl;
-(void)didShowInfoWithMessage:(WKScriptMessage*)message;
@end
