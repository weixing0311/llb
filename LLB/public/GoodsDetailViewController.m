//
//  GoodsDetailViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/25.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()

@end

@implementation GoodsDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginSuccessJump" object:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    // Do any additional setup after loading the view.
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushOpenUrl:) name:@"loginSuccessJump" object:nil];

}
-(void)popToRootWithPage:(int)page
{
    [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = page-1;

}


-(void)pushOpenUrl:(NSNotification *)noti
{
    GoodsDetailViewController * de =[[GoodsDetailViewController alloc]init];
    de.urlStr = [UserModel shareInstance].loginOpenUrl;
    [UserModel shareInstance].loginOpenUrl = @"";
    de.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:de animated:YES];
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
