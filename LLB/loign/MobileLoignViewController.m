//
//  MobileLoignViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/13.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "MobileLoignViewController.h"
#import "FirstTabbarViewController.h"
#import "SecondTabbarViewController.h"
@interface MobileLoignViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sendSMSBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTf;
@property (weak, nonatomic) IBOutlet UITextField *smsTf;

@end

@implementation MobileLoignViewController
{
    NSTimer * _timer;
    NSInteger timeNumber;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sendSMS:(id)sender {
    timeNumber = 59;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    self.sendSMSBtn.enabled = NO;
    
    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:self.phoneNumTf.text forKey:@"mobile"];
    
    [[BaseSerVice sharedManager]post:@"api/user/sendSMS.do" paramters:param success:^(NSDictionary *dic) {
        NSDictionary *dict = dic;
        NSString * status = [dict objectForKey:@"status"];
        NSString * msg ;
        if (![status isEqualToString:@"success"]) {
            msg =[dic objectForKey:@"message"];
            [_timer invalidate];
            [self.sendSMSBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.sendSMSBtn.enabled = YES;
            
        }else{
            msg = @"已发送";
        }
        DLog(@"%@",msg);
        [[UserModel shareInstance] showSuccessWithStatus:msg];
        
        
    } failure:^(NSError *error) {
        NSLog(@"faile--%@",error);
        [_timer invalidate];
        [self.sendSMSBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.sendSMSBtn.enabled = YES;
        
        NSDictionary *dic = error.userInfo;
        if ([[dic allKeys]containsObject:@"message"]) {
            UIAlertController *al = [UIAlertController alertControllerWithTitle:@"提示" message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:al animated:YES completion:nil];
            
        }else{
            [[UserModel shareInstance] showErrorWithStatus:@"发送失败"];
        }
        
    }];
    

}
- (IBAction)didLoign:(id)sender {
    if ([self.phoneNumTf.text isEqualToString:@""]||[self.phoneNumTf.text isEqualToString:@" "]||!self.phoneNumTf.text) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([self.smsTf.text isEqualToString:@""]||[self.smsTf.text isEqualToString:@" "]||!self.smsTf.text) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入验证码"];
        return;
    }
    [self.smsTf resignFirstResponder];
    [self.phoneNumTf resignFirstResponder];
    NSString * phone = [NSString stringWithFormat:@"%@",self.phoneNumTf.text];
    NSString * encryPhoneNum = [NSString encryptString:phone];

    [self didLoignLastWithType:@"1" content:phone msm:self.smsTf.text];
    

}
- (IBAction)showInfomation:(id)sender {
}

-(void)refreshTime
{
    if (timeNumber ==0) {
        [_timer invalidate];
        [self.sendSMSBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.sendSMSBtn.enabled = YES;
        return;
    }
    NSLog(@"%ld",(long)timeNumber);
    [self.sendSMSBtn setTitle:[NSString stringWithFormat: @"%ld",(long)timeNumber] forState:UIControlStateNormal];
    timeNumber --;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([self.smsTf isFirstResponder]) {
        [self didLoign:nil];
    }
    
    [self.phoneNumTf resignFirstResponder];
    [self.smsTf resignFirstResponder];
    return YES;
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
