//
//  SearchResultViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/25.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchHistoryCell.h"

@interface SearchResultViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UITextField                * searchtf;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout * layout;
@property (weak, nonatomic) IBOutlet UICollectionView           * collectionView;
@property (nonatomic,strong)         NSMutableArray             * dataArray;

@end

@implementation SearchResultViewController
{
    NSInteger page;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dataArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryUserDefaults"];
    [self.collectionView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryUserDefaults"];

    // Do any additional setup after loading the view from its nib.
    self.searchtf.delegate = self;
    [self.searchtf becomeFirstResponder];
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchHistoryCell" bundle:nil]forCellWithReuseIdentifier: @"SearchHistoryCell"];
    [self.collectionView.mj_header beginRefreshing];
}


- (IBAction)didBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 40, 5, 5);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * searchTextStr = [self.dataArray objectAtIndex:indexPath.row];
    SearchHistoryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"SearchHistoryCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.searchlb.text = searchTextStr;
    
    
    
    return cell;
}
//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * searchTextStr = [self.dataArray objectAtIndex:indexPath.row];
    float width = [searchTextStr widthForLabelWithHeight:30 isFont:[UIFont systemFontOfSize:15]];
    return CGSizeMake(width+10,30);
}
//这个是两行cell之间的间距（上下行cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//两个cell之间的间距（同一行的cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (self.searchtf.text.length>1) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryUserDefaults"]) {
            [arr addObjectsFromArray: [[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryUserDefaults"]];
        }
        [arr insertObject:self.searchtf.text atIndex:0];
        
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"searchHistoryUserDefaults"];
    }
    
    
    BaseWebViewController * wb =[[BaseWebViewController alloc]init];
    wb.urlStr = [[NSString stringWithFormat:@"app/searchList.html?t=%@&productName=%@",[NSString getNowTimeTimestamp3],_searchtf.text] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    wb.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wb animated:YES];
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
