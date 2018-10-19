//
//  BaseLoignViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/18.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseLoignViewController.h"
#import "FirstTabbarViewController.h"
#import "SecondTabbarViewController.h"
#import "MobileLoignViewController.h"
@interface BaseLoignViewController ()

@end

@implementation BaseLoignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

///微信个人信息传回后台
-(void)didLoignLastWithType:(NSString *)type content:(NSString *)content msm:(NSString *)msm
{
        NSMutableDictionary *param =[ NSMutableDictionary dictionary];
        [param setObject:content forKey:@"content"];
        [param setObject:type forKey:@"type"];
        if ([type isEqualToString:@"1"]) {
            [param safeSetObject:msm forKey:@"smsMsg"];
        }
        DLog(@"param--%@",param);
        [SVProgressHUD showWithStatus:@"登录中。。。"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [[BaseSerVice sharedManager]post:@"api/user/synthesize.do" hiddenHud:NO paramters:param  success:^(NSDictionary *dic) {
            [SVProgressHUD dismiss];
            [[UserModel shareInstance] showSuccessWithStatus:@"登录成功"];
            
            
            NSString * isBind = [NSString stringWithFormat:@"%@",[[dic safeObjectForKey:@"data"]safeObjectForKey:@"isBind"]];
            
            
            if ([type isEqualToString:@"2"]&&[isBind isEqualToString:@"1"]) {
                MobileLoignViewController * mb = [[MobileLoignViewController alloc]init];
                mb.isLogin = NO;
                mb.loginInfoDict  = [dic safeObjectForKey:@"data"];
                [self.navigationController pushViewController:mb animated:YES];
            }else{
                [[UserModel shareInstance]setInfoWithDic:[dic safeObjectForKey:@"data"]];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    
                    if ([UserModel shareInstance].loginOpenUrl !=nil&&[UserModel shareInstance].loginOpenUrl !=NULL ){// &&[UserModel shareInstance].loginOpenUrl.length>5) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccessJump" object:nil];
                    }
                }];
                
            }
        } failure:^(NSError *error) {
            
        }];
    
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
