//
//  WXAlipayController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WXAlipayController.h"
#import "PaySuccessViewController.h"
@interface WXAlipayController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@end

@implementation WXAlipayController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //    self.navigationController.navigationBar.hidden = YES;;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)appWillEnterForegroundNotification
{
    [self getNet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setTBRedColor];
    self.title = @"微信支付";
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * bgView =[[UIView alloc]initWithFrame:self.view.bounds];
    bgView.backgroundColor = HEXCOLOR(0xeeeeee);
    [self.view addSubview:bgView];

    NSMutableArray * arr =[NSMutableArray arrayWithArray:self.navigationController.viewControllers ];
    [arr removeObjectAtIndex:arr.count-2];
    [self.navigationController setViewControllers:arr];

    [self loadWChat];
    [self buildBtnView];
    
}
-(void)getNet
{
//    NSDictionary * dic =[[UserModel shareInstance]getURLParameters:self.orderNoUrl];
//    
//    NSMutableDictionary * params =[NSMutableDictionary dictionary];
//    [params safeSetObject:[dic objectForKey:@"orderNo"] forKey:@"orderNo"];
//    self.currentTasks = [[BaseSservice sharedManager]post1:@"pay/lakalapay/lakalaOrderPayStatus.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
//        int payStatus = [[dic safeObjectForKey:@"payStatus"]intValue];
//        if (payStatus ==2) {
//            PaySuccessViewController * success =[[PaySuccessViewController alloc]init];
//            success.paySuccess = YES;
//            success.orderType = [[dic safeObjectForKey:@"orderType"]intValue];
//            [self.navigationController pushViewController:success animated:YES];
//        }else{
//            [[UserModel shareInstance]showInfoWithStatus:@"支付失败"];
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
}

-(void)buildBtnView
{
    UIView * btnView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH-60, 100)];
    btnView.layer.masksToBounds = YES;
    btnView.layer.cornerRadius = 5;
    btnView.backgroundColor =HEXCOLOR(0xeeeeee);
    btnView.layer.borderWidth = 1;
    btnView.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    btnView.center = CGPointMake(JFA_SCREEN_WIDTH/2, JFA_SCREEN_HEIGHT/2);
    [self.view addSubview:btnView];
    
    UIButton *button1 =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH-60, 49)];
    [button1 setTitle:@"已经完成支付" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(getweChatPayResult) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor =[UIColor whiteColor];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnView addSubview:button1];
    UIButton *button2 =[[UIButton alloc]initWithFrame:CGRectMake(0, 50, JFA_SCREEN_WIDTH-60, 49)];
    [button2 addTarget:self action:@selector(reWeChatPay) forControlEvents:UIControlEventTouchUpInside];
    button2.backgroundColor =[UIColor whiteColor];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [button2 setTitle:@"支付遇到问题，重新支付" forState:UIControlStateNormal];
    [btnView addSubview:button2];

}
-(void)getweChatPayResult
{
    [self getNet];
}
-(void)reWeChatPay
{
    [self loadWChat];
}

-(void)loadWChat
{
    if ([self.urlStr containsString:kMyBaseUrl]) {
        self.urlStr = [self.urlStr stringByReplacingOccurrencesOfString:kMyBaseUrl withString:@""];
    }
    
    //解决wkwebview weixin://无法打开微信客户端的处理
    __weak WXAlipayController * weakself =self;
    if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlStr] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
            
            [weakself payResult:@""];
            
            
        }];
    } else {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.urlStr]];
    }

}

-(void)payResult:(NSString *)result
{
    PaySuccessViewController * success =[[PaySuccessViewController alloc]init];
    success.paySuccess = success;
    [self.navigationController pushViewController:success animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
