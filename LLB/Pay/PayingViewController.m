//
//  PayingViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/10/17.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "PayingViewController.h"
#import "WXAlipayController.h"
@interface PayingViewController ()

@end

@implementation PayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterWxPayResult) name:@"refreshWXPayWebView" object:nil];

    // Do any additional setup after loading the view.
}
-(void)enterWxPayResult
{
    if ([self.urlStr isEqualToString:self.wxPayCallBackUrl]) {
        return;
    }
    DLog(@"调用次数------------------------------------------------%@",self.orderUrl);
    
    WXAlipayController  * pay =[[WXAlipayController alloc]init];
    pay.urlStr =self.wxPayCallBackUrl;
    if (pay.urlStr.length<1) {
        return;
    }
    pay.wxPayCallBackUrl = self.wxPayCallBackUrl;
    pay.orderUrl = self.orderUrl;
    [self.navigationController pushViewController:pay animated:YES];
    
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
