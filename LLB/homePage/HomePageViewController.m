//
//  HomePageViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/13.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "HomePageViewController.h"
#import "ADCarouselView.h"
#import "HomePageHeadCell.h"
#import "PublicGoodsCell.h"
#import "HomeAdCell.h"
#import "HomeTitleCell.h"
@interface HomePageViewController ()
<ADCarouselViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UITableView * classtb;
@property (nonatomic,strong)NSMutableArray * classArr;
@property (strong, nonatomic)  UICollectionViewFlowLayout *layout;
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (nonatomic,strong)   NSDictionary * infoDict;
@property (nonatomic,strong)   NSMutableArray * dataArray;
@property (nonatomic,assign)   int  page;
@property (nonatomic,strong)NSMutableArray * bannerArray;
@property (nonatomic,strong)NSMutableArray * titleArray;
@property (nonatomic,strong)NSMutableArray * adArray;
@property (nonatomic,strong)NSMutableArray * notifiArray;
@property (nonatomic,assign)NSInteger notifacationCount;

@end

@implementation HomePageViewController
{
    ADCarouselView * adCar;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    [self buildCollectionView];
    [self getBannerInfo];
    [self getADInfo];
    [self getRoldInfo];
    [self getDataInfo];
    
    // Do any additional setup after loading the view.
}

#pragma mark ---Network request
///获取banner
-(void)getBannerInfo
{
    
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:@"1" forKey:@"bannerType"];
    [[BaseSerVice sharedManager]post:@"api/news/querySellerBannerList.do" paramters:params success:^(NSDictionary *dic) {
        
        [self.bannerArray removeAllObjects];
        [self.bannerArray addObjectsFromArray:[[dic safeObjectForKey:@"data"]objectForKey:@"array"]];
        [self.collectionView reloadData];
        
        /*
         
         : [{
         "imgUrl": "http://image.zainagou.com/images/productPicture/14661.jpg", //图片全路径
         "id": 1,    //ID
         "createTime": "",
         "pathUrl": "12",  //跳转路径
         "sort": 1,   //排序
         "updateTime": "2018-08-30 17:48:11",
         "bannerType": 1,
         "name": "123",    //轮播图名称
         "operaterName": "",
         "operaterID": "",
         "isValid": 0
         }]

         */
        
    } failure:^(NSError *error) {
        
    }];

}
///查看广告
-(void)getADInfo
{
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:@"2" forKey:@"bannerType"];
    [[BaseSerVice sharedManager]post:@"api/news/querySellerBannerList.do" paramters:params success:^(NSDictionary *dic) {
        
        [self.adArray removeAllObjects];
        [self.adArray addObjectsFromArray:[[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"]];
        [self.collectionView reloadData];
        
        /*
         
         : [{
         "imgUrl": "http://image.zainagou.com/images/productPicture/14661.jpg", //图片全路径
         "id": 1,    //ID
         "createTime": "",
         "pathUrl": "12",  //跳转路径
         "sort": 1,   //排序
         "updateTime": "2018-08-30 17:48:11",
         "bannerType": 1,
         "name": "123",    //轮播图名称
         "operaterName": "",
         "operaterID": "",
         "isValid": 0
         }]
         
         */
        
    } failure:^(NSError *error) {
        
    }];

}

///查看滚动消息
-(void)getRoldInfo
{
    [[BaseSerVice sharedManager]post:@"api/news/queryRollingNewsList.do" paramters:nil success:^(NSDictionary *dic) {
        [self.notifiArray addObjectsFromArray:[[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"]];
        [self.collectionView reloadData];

        /*
         
         "array": [{
         "id": 3,   //id
         "createTime": "234",
         "title": "23423",  //消息标题
         "titleUrl": "234",  //跳转页面
         "readNum": 234,  //阅读量
         "isRolling": 1,  //0不滚动 1 滚动
         "updateTime": "234",
         "imgPath": "234",  //图片地址
         "operaterName": "234",
         "operaterId": "234",
         "newsType": 2,  //消息类型Id
         "isValid": 0
         }]
         */
        
    } failure:^(NSError *error) {
        
    }];

}

-(void)getAllUnReadNotificationInfo
{
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId  forKey:@"userId"];

    [[BaseSerVice sharedManager]post:@"api/news/queryRollingNewsList.do" paramters:nil success:^(NSDictionary *dic) {
        self.notifacationCount = [[[dic safeObjectForKey:@"data"]objectForKey:@"count"]integerValue];
        /*
         
         "count": 200   //数量

         */
        
    } failure:^(NSError *error) {
        
    }];

}
-(void)getDataInfo
{
    
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId  forKey:@"userId"];
    
    [[BaseSerVice sharedManager]post:@"api/product/queryProductHotList.do" paramters:nil success:^(NSDictionary *dic) {
        
        NSArray * arr =[[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"];
        
        [self.dataArray addObjectsFromArray:arr];
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];

}

-(void)buildCollectionView
{
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH,height(self.view)) collectionViewLayout:_layout];
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeTitleCell" bundle:nil]forCellWithReuseIdentifier: @"HomeTitleCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeAdCell" bundle:nil]forCellWithReuseIdentifier: @"HomeAdCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomePageHeadCell" bundle:nil]forCellWithReuseIdentifier: @"HomePageHeadCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PublicGoodsCell" bundle:nil]forCellWithReuseIdentifier: @"PublicGoodsCell"];

    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    [self.view addSubview:self.collectionView];
    
    
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)headerRereshing
{
    [self getDataInfo];
    [self getBannerInfo];
    [self getADInfo];
    [self getRoldInfo];
}

-(void)setRefrshWithCollectionView:(UICollectionView *)co
{
    
    co.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
//    co.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [co.mj_header beginRefreshing];
    
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.titleArray.count;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return self.adArray.count;
            break;

        default:
            return self.dataArray.count;
            break;
    }
    
    return self.dataArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/2);
    }
    else if (section ==1)
    {
        return CGSizeMake(JFA_SCREEN_WIDTH, 1);
    }
    else if (section ==2)
    {
        return CGSizeMake(JFA_SCREEN_WIDTH, 1);
        
    }else if(section ==3)
    {
        return CGSizeMake(JFA_SCREEN_WIDTH, 50);
    }else{
        return CGSizeMake(1, 1);
    }
    

}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        NSDictionary * dict = [self.titleArray objectAtIndex:indexPath.row];
        HomeTitleCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"HomeTitleCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"logo_")];
        cell.titlelb .text = [dict safeObjectForKey:@"productName"];
        return cell;
        
    }
    else if (indexPath.section ==1)
    {
//        NSDictionary * dict = [self.adArray objectAtIndex:indexPath.row];
        HomeAdCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAdCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
//        cell.titlelb .text = [dict safeObjectForKey:@"productName"];
        return cell;
        
    }
    else if (indexPath.section ==2)
    {
        NSDictionary * dict = [self.dataArray objectAtIndex:indexPath.row];
        HomePageHeadCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHeadCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"logo_")];
        return cell;
        
    }
    else{
        NSDictionary * dict = [self.dataArray objectAtIndex:indexPath.row];
        PublicGoodsCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PublicGoodsCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"logo_")];
        cell.goodstitlelb .text = [dict safeObjectForKey:@"productName"];
        cell.pricelb.text = [NSString stringWithFormat:@"￥%.1f",[[dict safeObjectForKey:@"productPrice"]doubleValue]];
        return cell;
        
    }
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/4-10, (JFA_SCREEN_WIDTH-20)/4);
    }
    else if (indexPath.section==1)
    {
        return CGSizeMake(JFA_SCREEN_WIDTH-20, 50);
    }
    else if (indexPath.section==2)
    {
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/2, (JFA_SCREEN_WIDTH-20)/2/0.68);
    }
    
    return CGSizeMake((JFA_SCREEN_WIDTH-20)/2-10, (JFA_SCREEN_WIDTH-20)/2+60);
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



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                withReuseIdentifier:@"headView"forIndexPath:indexPath];
        
        headView.backgroundColor = HEXCOLOR(0xffffff);
        
        for (UIView *view in [headView subviews]) {
            [view removeFromSuperview];
        }

        
        if (indexPath.section==0) {
            adCar = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/2)];
            adCar.loop = YES;
            adCar.delegate = self;
            adCar.imgs = @[@"test1",@"test1",@"test1",@"test1",@"test1",@"test1"];
            adCar.automaticallyScrollDuration = 5;
            adCar.placeholderImage = [UIImage imageNamed:@"logo_"];
            [headView addSubview:adCar];
            
            
            
            UIView * searchView = [UIView new];
            searchView.frame = CGRectMake(20,20 , JFA_SCREEN_WIDTH-40-40, 40);
            searchView.backgroundColor = [UIColor whiteColor];
            searchView.layer.masksToBounds = YES;
            searchView.layer.cornerRadius =20;

            [headView addSubview:searchView];

            
            UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
            imgV.image = getImage(@"search_logo");
            [searchView addSubview:imgV];
            
            
            
            
            
            UIButton * searchBtn = [UIButton new];
            searchBtn.frame = CGRectMake(10,20 , JFA_SCREEN_WIDTH-70, 40);
            [searchBtn addTarget:self action:@selector(didSearch) forControlEvents:UIControlEventTouchUpInside];
            [searchView addSubview:searchBtn];
            
            UIButton * msgBtn = [UIButton new];
        
            msgBtn.frame = CGRectMake(JFA_SCREEN_WIDTH-50,20 , 40, 40);
            searchView.layer.masksToBounds = YES;
            searchView.layer.cornerRadius =20;

            [msgBtn addTarget:self action:@selector(showMsg) forControlEvents:UIControlEventTouchUpInside];
            msgBtn.backgroundColor = RGBACOLOR(225/225.0f, 225/225.0f, 225/225.0f, 0.6);
            [msgBtn setImage:getImage(@"msg_") forState:UIControlStateNormal];
            [headView addSubview:msgBtn];

            
        }
        else if (indexPath.section==1)
        {
            
        }
        else if (indexPath.section==2)
        {
            
        }
        else if(indexPath.section==3){
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/2-70, 15, 140, 20)];
            image.image = getImage(@"hot_goods_title_");
            [headView addSubview:image];
        }
        
        return headView;
    }
    return nil;
}

















#pragma mark ---collectionView methods








-(NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
-(NSMutableArray *)notifiArray
{
    if (!_notifiArray) {
        _notifiArray = [NSMutableArray array];
    }
    return _notifiArray;
}
-(NSMutableArray *)adArray
{
    if (!_adArray) {
        _adArray = [NSMutableArray array];
    }
    return _adArray;
}
-(void)showMsg
{
    DLog(@"showMEssage");
}
-(void)didSearch
{
    DLog(@"showSearch");
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