//
//  LoignViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/13.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "LoignViewController.h"
#import "MobileLoignViewController.h"
#import "FirstTabbarViewController.h"
#import "SecondTabbarViewController.h"
#import "AgreeMentViewController.h"
@interface LoignViewController ()

@end

@implementation LoignViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didwxLoign:) name:@"wxloignSuccess" object:nil];
    // Do any additional setup after loading the view from its nib.
}
///开始微信授权请求
- (IBAction)loignWithWX:(id)sender {
    
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq * request = [[SendAuthReq alloc]init];
        request.state = @"linlinbangweixinloignstate";
        request.scope = @"snsapi_userinfo";
        [WXApi sendReq:request];
    }
}
///授权请求成功-开始请求openid和access_token
-(void)didwxLoign:(NSNotification*)noti
{
    
    
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:kWeixinKey forKey:@"appid"];
    [params safeSetObject:kWeixinSecret forKey:@"secret"];
    [params safeSetObject:[noti.userInfo objectForKey:@"code"] forKey:@"code"];
    [params safeSetObject:@"authorization_code" forKey:@"grant_type"];
    
    [[BaseSerVice sharedManager]postBaidu:@"https://api.weixin.qq.com/sns/oauth2/access_token" paramters:params success:^(NSDictionary *dic) {
        DLog(@"微信返回：%@",dic);

        [self getWXUserInfoWithInfo:dic];
        
    } failure:^(NSError *error) {
        
    }];
}
///请求微信用户个人信息
-(void)getWXUserInfoWithInfo:(NSDictionary *)dict
{
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:dict[@"openid"] forKey:@"openid"];
    [params safeSetObject:dict[@"access_token"] forKey:@"access_token"];
    
    [[BaseSerVice sharedManager]postBaidu:@"https://api.weixin.qq.com/sns/userinfo" paramters:params success:^(NSDictionary *dic) {
        DLog(@"微信返回：%@",dic);
        
//        NSString * openid = [dic safeObjectForKey:@"openid"];
        
        NSString * content = [self DataTOjsonString:dic];
        [self didLoignLastWithType:@"2" content:content msm:nil];
        
    } failure:^(NSError *error) {
        
    }];

}


- (IBAction)otherLoign:(id)sender {
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"手机号登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MobileLoignViewController * mb =[[MobileLoignViewController alloc]init];
        mb.isLogin =YES;
        [self.navigationController pushViewController:mb animated:YES];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:al animated:YES completion:^{
        
    }];
}
- (IBAction)goBack:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)agreement:(id)sender {
    
    AgreeMentViewController * ag =[[AgreeMentViewController alloc]init];
    ag.urlStr = @"app/AgreementList.html";
    [self.navigationController pushViewController:ag animated:YES];
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
