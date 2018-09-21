//
//  BaseCollectionViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/14.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseCollectionViewController.h"
@interface BaseCollectionViewController ()

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page =1;
    [self collectionView];
    // Do any additional setup after loading the view.
}


-(void)setCollectionViewHead
{
   // [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];

}
-(void)setCollectionViewCell
{
  //  [self.collectionView registerNib:[UINib nibWithNibName:@"" bundle:nil]forCellWithReuseIdentifier: @""];

}



-(CGSize)setCollectionViewItemSizeWithSection:(NSInteger)section
{
    return CGSizeZero;
}


-(CGSize)setCollectionViewHeaderSizeWithSection:(NSInteger)section
{
    return CGSizeZero;
}

-(void)didClickItemWithIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView*)createHeaderViewWithInfo:(NSDictionary *)infoDict indexPath:(NSIndexPath *)indexPath
{
    return nil;
}
-(BaseCollectionCell *)createItemWithIndexPath:(NSIndexPath *)indexPath
{
    BaseCellModel * model = [_dataArray objectAtIndex:indexPath.row];
    
    NSString * cellIdentification=[model cellXibName]?[model cellXibName]:[model cellClassName];
    
    BaseCollectionCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellIdentification forIndexPath:indexPath];
    
    //    BaseTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentification];
    
    if (!cell&&[model cellXibName]) {
        
        cell=[[[NSBundle mainBundle] loadNibNamed:[model cellXibName] owner:self options:0] objectAtIndex:0];
    }
    
    if (!cell&&[model cellClassName]) {
        
        cell=[[NSClassFromString(cellIdentification) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentification];
    }
    cell.tag = indexPath.row;
    cell.model = model;
    cell.indexCount = indexPath.row;
    return cell;

}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:_layout];
        self.collectionView.delegate = self;
        self.collectionView.alwaysBounceVertical = YES;//实现代理
        self.collectionView.dataSource = self;                  //实现数据源方法
        self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
        self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
        
        
        [self setCollectionViewHead];
        [self setCollectionViewCell];
        [self.view addSubview:self.collectionView];

    }
    return _collectionView;
}


-(NSInteger)sectionCount
{
    return 1;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(void)headerRereshing
{
    self.page = 1;
    [self getDataInfo];
}
-(void)footerRereshing
{
    self.page ++;
    [self getDataInfo];
}

-(void)getDataInfo
{
    
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(void)setRefrshWithCollectionView:(UICollectionView *)co
{
    
    co.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    co.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [co.mj_header beginRefreshing];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    return [self setCollectionViewHeaderSizeWithSection:section];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _sectionCount;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:_sectionCount];
//    return self.dataArray.count;
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self createItemWithIndexPath:indexPath];
    
    
//    NSDictionary * dict = [self.dataArray objectAtIndex:indexPath.row];
//    GoodsDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsDetailCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//    [cell.BigImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"logo_")];
//    cell.titlelb .text = [dict safeObjectForKey:@"productName"];
//    cell.pricelb.text = [NSString stringWithFormat:@"￥%.1f",[[dict safeObjectForKey:@"productPrice"]doubleValue]];
//    return cell;
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self setCollectionViewItemSizeWithSection:indexPath.section];
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
    
    [self didClickItemWithIndexPath:indexPath];
//    NSDictionary * dict = [self.dataArray objectAtIndex:indexPath.row];
//
//    DPDetailViewController * detai =[[DPDetailViewController alloc]init];
//    detai.productNo = [dict safeObjectForKey:@"productNo"];
//    [self.navigationController pushViewController:detai animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                withReuseIdentifier:@"headView"forIndexPath:indexPath];
        
        headView.backgroundColor = HEXCOLOR(0xffffff);
        
        
        UIView * view = [self createHeaderViewWithInfo:self.infoDict indexPath:indexPath];
        [headView addSubview:view];
        return headView;
    }
    return nil;
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
