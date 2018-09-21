//
//  SecondTabbarViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/13.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "SecondTabbarViewController.h"
#import "ClassIficationViewController.h"
#import "HomePageViewController.h"
#import "MineViewController.h"
#import "ShopCarViewController.h"
@interface SecondTabbarViewController ()

@end

@implementation SecondTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomePageViewController * hp = [[HomePageViewController alloc]init];
    
    //    health = [[HealthViewController alloc]init];
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:hp];
    hp.title = @"主页";
    
    
    ClassIficationViewController * cs = [[ClassIficationViewController alloc]init];
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:cs];
    cs.title = @"消息";
    
    
    
    BaseWebViewController *thirdVC = [[BaseWebViewController alloc]init];
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:thirdVC];
    thirdVC.title = @"社群";
    
    
    
    ShopCarViewController * shopCar = [[ShopCarViewController alloc]init];
    UINavigationController * nav4 = [[UINavigationController alloc]initWithRootViewController:shopCar];
    shopCar.title = @"我的";
    
    MineViewController * mine = [[MineViewController alloc]init];
    UINavigationController * nav5 = [[UINavigationController alloc]initWithRootViewController:mine];
    mine.title = @"我的";

    
    self.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
    
    
    UITabBarItem * item1 =[self.tabBar.items objectAtIndex:0];
    UITabBarItem * item2 =[self.tabBar.items objectAtIndex:1];
    UITabBarItem * item3 =[self.tabBar.items objectAtIndex:2];
    UITabBarItem * item4 =[self.tabBar.items objectAtIndex:3];
    UITabBarItem * item5 =[self.tabBar.items objectAtIndex:4];

    item1.image = [UIImage imageNamed:@"tabbar_1_"];
    item2.image = [UIImage imageNamed:@"tabbar_2_"];
    item3.image = [UIImage imageNamed:@"tabbar_3_"];
    item4.image = [UIImage imageNamed:@"tabbar_4_"];
    item5.image = [UIImage imageNamed:@"tabbar_5_"];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor redColor];

    
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
