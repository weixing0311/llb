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

    [[BaseSerVice sharedManager]post:@"api/user/synthesize.do" paramters:param  success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] showSuccessWithStatus:@"登录成功"];
        
        [[UserModel shareInstance]setInfoWithDic:[dic safeObjectForKey:@"data"]];
        
        NSDictionary * dataDict= [dic safeObjectForKey:@"data"];
        //        NSString * isHasReport =[dataDict safeObjectForKey:@"isHasReport"];
        //        if ([isHasReport isEqualToString:@"1"]) {
        FirstTabbarViewController *tab = [[FirstTabbarViewController alloc]init];
        self.view.window.rootViewController = tab;
        
        //        }else{
        //            SecondTabbarViewController * fa = [[SecondTabbarViewController alloc]init];
        //            [self.navigationController pushViewController:fa animated:YES];
        //
        //        }
        
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
