//
//  ClassIficationViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/13.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "ClassIficationViewController.h"
#import "ClassInofoModel.h"
#import "ClassInfoCollectionViewCell.h"
#import "GoodsDetailViewController.h"
@interface ClassIficationViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)   UITableView * classtb;
@property (nonatomic,strong)   NSMutableArray * classArr;
@property (strong, nonatomic)  UICollectionViewFlowLayout *layout;
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (nonatomic,strong)   NSDictionary * infoDict;
@property (nonatomic,strong)   NSMutableArray * dataArray;
@property (nonatomic,strong)   NSMutableArray * sectionArray;
@property (nonatomic,strong)   NSMutableArray * brandArray;
@property (nonatomic,assign)   int  page;

@end

@implementation ClassIficationViewController
{
    NSString * classId;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    page =1;
    // Do any additional setup after loading the view.
    [self classtb];
    [self buildCollectionView];
    [self setRefrshWithCollectionView:self.collectionView];
    [self getClassInfo];
    [self getbrand];
}
-(void)buildCollectionView
{
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(80, 0, JFA_SCREEN_WIDTH-80,self.view.frame.size.height) collectionViewLayout:_layout];
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
    self.layout.headerReferenceSize=CGSizeMake(JFA_SCREEN_WIDTH,40);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.tintColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ClassInfoCollectionViewCell" bundle:nil]forCellWithReuseIdentifier: @"ClassInfoCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];

    [self.view addSubview:self.collectionView];


}
-(void)getClassInfo
{
    [[BaseSerVice sharedManager]post:@"api/product/queryOneClassList.do" paramters:nil success:^(NSDictionary *dic) {
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        _classArr = [dataDict safeObjectForKey:@"array"];
        
        [_classtb reloadData];

        if (_classArr.count>0) {
            NSDictionary * firstDict = [_classArr objectAtIndex:0];
            classId = [firstDict objectForKey:@"id"];
            [self getDataInfo];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)getDataInfo
{
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:classId forKey:@"classId"];
    [[BaseSerVice sharedManager]post:@"api/product/queryTweClassList.do" paramters:params success:^(NSDictionary *dic) {
        
        
        [self.collectionView.mj_header endRefreshing];
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        
        NSArray * infoArr =[dataDict safeObjectForKey:@"classArray"];
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:infoArr];;
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];

        [self.dataArray removeAllObjects];
        [self.collectionView reloadData];
    }];

}

//获取品牌
-(void)getbrand
{
    [[BaseSerVice sharedManager]post:@"api/product/queryBrandList.do" paramters:nil success:^(NSDictionary *dic) {
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        _brandArray = [dataDict safeObjectForKey:@"brandArray"];
        
        [_collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark ---tableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _classArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier  =@"classCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary * dic = [self.classArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic safeObjectForKey:@"className"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = HEXCOLOR(0x666666);
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict =[_classArr objectAtIndex:indexPath.row];
    classId = [dict safeObjectForKey:@"id"];
    [self getDataInfo];
}




#pragma mark --collectionView---


-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}
-(void)headerRereshing
{
    [self getDataInfo];
}

-(void)setRefrshWithCollectionView:(UICollectionView *)co
{
    
    co.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
//    co.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [co.mj_header beginRefreshing];
    
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section ==0) {
        return self.dataArray.count ;
    }
    else
    {
        return _brandArray.count;
    }
//    NSDictionary * dic = [self.dataArray objectAtIndex:section];
//    NSArray * itemsArr = [dic objectForKey:@"brandArray"];
//    return itemsArr.count;
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 40, 5, 5);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        NSDictionary * dataDict =[self.dataArray objectAtIndex:indexPath.row];
        
        ClassInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassInfoCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[dataDict safeObjectForKey:@"classPicture"]] placeholderImage:getImage(@"default_")];
        cell.titlelb .text = [dataDict safeObjectForKey:@"className"];
        return cell;

    }else{
        NSDictionary * dataDict =[self.brandArray objectAtIndex:indexPath.row];
        ClassInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassInfoCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[dataDict safeObjectForKey:@"logo"]] placeholderImage:getImage(@"default_")];
        cell.titlelb .text = [dataDict safeObjectForKey:@"cname"];
        return cell;

    }

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
        
//        NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.section];
//
//        //添加头视图的内容
        UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 5)];
        lineView.backgroundColor = HEXCOLOR(0xeeeeee);
        [view addSubview:lineView];

        UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
        titleLabel.text = indexPath.section==1?@"品牌":@"";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = HEXCOLOR(0x666666);
        [view addSubview:titleLabel];

        //头视图添加view
        [header addSubview:view];
        return header;
    }
    //如果底部视图
    //    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
    //    }
    return nil;
}
//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((JFA_SCREEN_WIDTH-140)/3, (JFA_SCREEN_WIDTH-140)/3);
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
    
    GoodsDetailViewController * gs = [[GoodsDetailViewController alloc]init];
    gs.hidesBottomBarWhenPushed = YES;

    NSString * timeStr = [NSString getNowTimeTimestamp3];

    if (indexPath.section ==0) {
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        
        gs.urlStr =  [[NSString stringWithFormat:@"app/productList.html?t=%@&classId=%@&groupId=%@&name=%@",timeStr,[dic safeObjectForKey:@"id"],classId,[dic safeObjectForKey:@"className"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        

    }else{
       NSDictionary * dic = [self.brandArray objectAtIndex:indexPath.row];
        
        NSString * nameStr = [dic safeObjectForKey:@"cname"];
        NSString * brandld = [dic safeObjectForKey:@"id"];
        gs.urlStr =  [[NSString stringWithFormat:@"app/productList.html?t=%@&brandId=%@&name=%@&classId=%@&groupId=",timeStr,brandld,nameStr,classId] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    }
    
    
    [self.navigationController pushViewController:gs animated:YES];

}




















-(UITableView *)classtb
{
    if (!_classtb) {
        _classtb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, self.view.frame.size.height) style:UITableViewStylePlain];
        _classtb.delegate = self;
        _classtb.dataSource =self;
        _classtb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_classtb];
    }
    return _classtb;
}
-(NSMutableArray *)classArr
{
    if (!_classArr) {
        _classArr  =[NSMutableArray array];
    }
    return _classArr;
}

-(NSMutableArray *)brandArray
{
    if (!_brandArray) {
        _brandArray  =[NSMutableArray array];
    }
    return _brandArray;
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
