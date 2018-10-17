//
//  PaySuccessViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "BaseWebViewController.h"
@interface PaySuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";

//    [self setTBRedColor];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBack)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_"] style:UIBarButtonItemStylePlain target:self action:@selector(enterRightPage)];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self changePageWithPayStatus];
}



-(void)changePageWithPayStatus
{
    if (self.paySuccess ==1) {
        self.statuslb.text = @"支付成功";
        self.statusImageView.image = getImage(@"zhiTrue");
        self.backBtn.backgroundColor = HEXCOLOR(0x1AAD18);

    }else if(self.paySuccess ==2){
        self.statuslb.text = @"支付失败";
        self.statusImageView.image = getImage(@"zhiFalse_");
        self.backBtn.backgroundColor = [UIColor redColor];

    }else{
        self.statuslb.text = @"支付取消";
        self.statusImageView.image = getImage(@"zhiFalse_");
        self.backBtn.backgroundColor = [UIColor redColor];

    }
}





-(void)didClickBack
{
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:arr[0]];
    if (![arr[1]isKindOfClass:[BaseWebViewController class]]) {
        [array addObject:arr[1]];
    }
    
    
    [self.navigationController setViewControllers:array];

}
-(void)enterRightPage
{
    [self paySuccessBackWithType:self.orderType];
}

- (IBAction)didpopToRootVc:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)paySuccessBackWithType:(int )orderType
{
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
    web.urlStr = self.orderUrl;
    [self.navigationController pushViewController:web animated:YES];
    
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
