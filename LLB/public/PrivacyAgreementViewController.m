//
//  PrivacyAgreementViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/10/18.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "PrivacyAgreementViewController.h"

@interface PrivacyAgreementViewController ()

@end

@implementation PrivacyAgreementViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
