//
//  OrderViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/10/17.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
     NSMutableArray *  newArr = [NSMutableArray array];
    [newArr addObject:arr[0]];
    [newArr addObject:[arr lastObject] ];
    
    [self.navigationController setViewControllers:newArr];

    
    
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
