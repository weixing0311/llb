//
//  SearchResultViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/25.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "SearchResultViewController.h"
#import "PublicGoodsCell.h"
@interface SearchResultViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UITextField                * searchtf;
@property (weak, nonatomic) IBOutlet UIView                     * bgView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout * layout;
@property (weak, nonatomic) IBOutlet UICollectionView           * collectionView;
@property (nonatomic,strong)         NSMutableArray             * dataArray;

@end

@implementation SearchResultViewController
{
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchtf.delegate = self;
    [self.searchtf becomeFirstResponder];
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
    [self.collectionView registerNib:[UINib nibWithNibName:@"PublicGoodsCell" bundle:nil]forCellWithReuseIdentifier: @"PublicGoodsCell"];
    self.bgView.hidden = YES;
    [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenIts)]];
    self.collectionView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)headerRereshing
{
    page = 1;
    [self getDataInfo];
}

-(void)getDataInfo
{
//
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    [params safeSetObject:@"100" forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"pageSize"];
    [params safeSetObject:@"10" forKey:@"productName"];

    [[BaseSerVice sharedManager]post:@"api/product/queryLikeProductList.do" paramters:params success:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)didBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hiddenIts
{
    self.bgView.hidden = YES;
    [self.searchtf resignFirstResponder];
    
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
    
    NSDictionary * dict = [self.dataArray objectAtIndex:indexPath.row];
    PublicGoodsCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PublicGoodsCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"default_")];
    
    
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // 对齐方式
    style.alignment = NSTextAlignmentJustified;
    // 首行缩进
    style.firstLineHeadIndent = 30.0f;
    // 头部缩进
    style.headIndent = 10.0f;
    // 尾部缩进
    style.tailIndent = -10.0f;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[dict safeObjectForKey:@"productName"] attributes:@{ NSParagraphStyleAttributeName : style}];
    cell.goodstitlelb.attributedText = attrText;
    
    
    cell.pricelb.text = [NSString stringWithFormat:@"￥%.1f",[[dict safeObjectForKey:@"productPrice"]doubleValue]];
    return cell;
}
//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((JFA_SCREEN_WIDTH-20)/2, (JFA_SCREEN_WIDTH-20)/2+80);
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


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.bgView.hidden = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.bgView.hidden = YES;
    
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
