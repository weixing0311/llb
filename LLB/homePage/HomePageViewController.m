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
#import "GoodsDetailViewController.h"
#import "SearchResultViewController.h"
#import "AdvertisingView.h"
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
    AdvertisingView* adv;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self showTabbar];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showADV:) name:@"kShowAdcPage" object:nil];
    self.view.backgroundColor = [UIColor redColor];
    [self buildCollectionView];
    [self setRefrshWithCollectionView:self.collectionView];
    [self getBannerInfo];
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
    [[BaseSerVice sharedManager]post:@"api/news/querySellerBannerList.do" hiddenHud:NO  paramters:params success:^(NSDictionary *dic) {
        [self.collectionView.mj_header endRefreshing];

        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        
        [self.bannerArray removeAllObjects];
        [self.titleArray removeAllObjects];
        [self.adArray removeAllObjects];

        
        [self.bannerArray addObjectsFromArray:[dataDic safeObjectForKey:@"lunboArray"]];
        [self.titleArray addObjectsFromArray:[dataDic safeObjectForKey:@"juzhengArray"]];
        [self.adArray addObjectsFromArray:[dataDic safeObjectForKey:@"guanggaoArray"]];

        NSArray * tanchuArray =[dataDic safeObjectForKey:@"tanchuArray"];
        if (tanchuArray.count>0) {
            [self showAdViewWithDict:tanchuArray[0]];
        }
        
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];

    }];

}


///查看滚动消息
-(void)getRoldInfo
{
    [[BaseSerVice sharedManager]post:@"api/news/queryRollingNewsList.do" hiddenHud:YES  paramters:nil success:^(NSDictionary *dic) {
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
        
        [self.notifiArray removeAllObjects];
        [self.collectionView reloadData];
        DLog(@"error-%@",error.userInfo);
    }];

}

//-(void)getAllUnReadNotificationInfo
//{
//    NSMutableDictionary * params =[NSMutableDictionary dictionary];
//    [params safeSetObject:[UserModel shareInstance].userId  forKey:@"userId"];
//
//    [[BaseSerVice sharedManager]post:@"api/news/queryRollingNewsList.do" paramters:nil success:^(NSDictionary *dic) {
//        self.notifacationCount = [[[dic safeObjectForKey:@"data"]objectForKey:@"count"]integerValue];
//        /*
//
//         "count": 200   //数量
//
//         */
//
//    } failure:^(NSError *error) {
//
//    }];
//
//}
-(void)getDataInfo
{
    
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId  forKey:@"userId"];
    
    [[BaseSerVice sharedManager]post:@"api/product/queryProductHotList.do" hiddenHud:NO  paramters:nil success:^(NSDictionary *dic) {
        [self.collectionView.mj_header endRefreshing];
        NSArray * arr =[[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:arr];
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];

    }];

}

-(void)buildCollectionView
{
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -20, JFA_SCREEN_WIDTH,height(self.view)) collectionViewLayout:_layout];
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= HEXCOLOR(0xFFFFFF);
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
            return self.notifiArray.count;
            break;
        case 2:
            return self.adArray.count;
            break;

        default:
            return self.dataArray.count;
            break;
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/2.29);
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
    if (section ==0) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }else
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        NSDictionary * dict = [self.titleArray objectAtIndex:indexPath.row];
        HomeTitleCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"HomeTitleCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"imgUrl"]] placeholderImage:getImage(@"default_")];
        cell.titlelb .text = [dict safeObjectForKey:@"name"];
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
        NSDictionary * dict = [self.adArray objectAtIndex:indexPath.row];
        HomePageHeadCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHeadCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"imgUrl"]] placeholderImage:getImage(@"banner_default_")];
        return cell;
        
    }
    else{
        NSDictionary * dict = [self.dataArray objectAtIndex:indexPath.row];
        PublicGoodsCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PublicGoodsCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"default_")];
        cell.backgroundColor = HEXCOLOR(0xeeeeee);
        cell.goodsStatelb.text = [dict safeObjectForKey:@"hotName"];
        
        int goodsCount  = [[dict safeObjectForKey:@"salesAmount"]intValue];
        double vipPrice = [[dict safeObjectForKey:@"vipPrice"]doubleValue];
        NSString * goodPrice = [dict safeObjectForKey:@"productPrice"];
        NSString * offsetPrice =[dict safeObjectForKey:@"offsetPrice"];
        
        
        if (!goodsCount||goodsCount<1) {
            cell.countlb.hidden = YES;
        }else{
            cell.countlb.hidden = NO;
        }
        
        if (!vipPrice||vipPrice<1) {
            cell.secPricelb.hidden = YES;
            cell.secImg.hidden = YES;
        }else{
            cell.secPricelb.hidden = NO;
            cell.secImg.hidden = NO;
        }
        if ([offsetPrice intValue]<1) {
            cell.quanbgView.hidden  = YES;
            cell.quanlb.hidden = YES;
        }else{
            cell.quanbgView.hidden = NO;
            cell.quanlb.hidden = NO;
        }
        
        
        
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString: goodPrice]; //创建一个NSMutableAttributedString
        
        
        [str3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(str3.length-3,  2)]; //关键步骤，设置指定位置文字的字号大小
        
//        self.textLabel.attributedText = str3;

        
        
        
        cell.quanlb.text = [NSString stringWithFormat:@"可抵现%@元",offsetPrice];
        cell.countlb.text = [NSString stringWithFormat:@"已售出%d件",goodsCount];
        cell.secPricelb.text = [NSString stringWithFormat:@"￥%.2f",vipPrice];
        cell.goodstitlelb.text = [dict safeObjectForKey:@"productName"];
        cell.pricelb.text = [NSString stringWithFormat:@"￥%@",goodPrice];
        return cell;
        
    }
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/4-10, (JFA_SCREEN_WIDTH-20)/4-10);
    }
    else if (indexPath.section==1)
    {
        return CGSizeMake(JFA_SCREEN_WIDTH-20, 50);
    }
    else if (indexPath.section==2)
    {
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/2, (JFA_SCREEN_WIDTH-20)/2/1.45);
    }
    
    return CGSizeMake((JFA_SCREEN_WIDTH-10)/2, (JFA_SCREEN_WIDTH-10)/2+100);
}
//这个是两行cell之间的间距（上下行cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//两个cell之间的间距（同一行的cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section ==0) {
        NSDictionary * dic = [self.titleArray objectAtIndex:indexPath.row];
        GoodsDetailViewController * gs = [[GoodsDetailViewController alloc]init];
        gs.hidesBottomBarWhenPushed = YES;
        
        NSString * url =[[dic safeObjectForKey:@"pathUrl"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ;
        gs.urlStr = url;
        [self.navigationController pushViewController:gs animated:YES];

    }
    else if (indexPath.section ==1)
    {
        
    }
    else if (indexPath.section ==2)
    {
        NSDictionary * dic = [self.adArray objectAtIndex:indexPath.row];
        GoodsDetailViewController * gs = [[GoodsDetailViewController alloc]init];
        gs.hidesBottomBarWhenPushed = YES;
        
        NSString * url =[[dic safeObjectForKey:@"pathUrl"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ;
        gs.urlStr = url;
        [self.navigationController pushViewController:gs animated:YES];

    }
    else
    {
        NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
        GoodsDetailViewController * gs = [[GoodsDetailViewController alloc]init];
        gs.hidesBottomBarWhenPushed = YES;
        
        NSString * timeStr = [NSString getNowTimeTimestamp3];
        NSString * productId = [dic safeObjectForKey:@"productNO"];
        NSString * url = [NSString stringWithFormat:@"app/commodity.html?t=%@&productId=%@&groupId=&shopId=",timeStr,productId];
        gs.urlStr = url;
        [self.navigationController pushViewController:gs animated:YES];
    }

    

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
            adCar = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/2.29)];
            adCar.loop = YES;
            adCar.delegate = self;
            
            NSMutableArray * imgArr = [NSMutableArray array];
            for (int i =0; i<self.bannerArray.count; i++) {
                NSDictionary * dic = [self.bannerArray objectAtIndex:i];
                NSString *img = [dic safeObjectForKey:@"imgUrl"];
                [imgArr addObject:img];
            }
            
            
            adCar.imgs = imgArr;
            adCar.automaticallyScrollDuration = 5;
            adCar.placeholderImage = [UIImage imageNamed:@"logo_"];
            [headView addSubview:adCar];
            
            
            
            UIView * searchView = [UIView new];
            searchView.frame = CGRectMake(10,20 , JFA_SCREEN_WIDTH-20, 30);
            searchView.backgroundColor = [UIColor whiteColor];
            searchView.layer.masksToBounds = YES;
            searchView.layer.cornerRadius =15;

            [headView addSubview:searchView];

            
            UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 14, 14)];
            imgV.image = getImage(@"search_logo");
            [searchView addSubview:imgV];
            
            
            
            
            
            UIButton * searchBtn = [UIButton new];
            searchBtn.frame = CGRectMake(0,0 , JFA_SCREEN_WIDTH-20, 30);
            [searchBtn addTarget:self action:@selector(didSearch) forControlEvents:UIControlEventTouchUpInside];
//            searchBtn.backgroundColor = [UIColor redColor];
            [searchView addSubview:searchBtn];
            
//            UIButton * msgBtn = [UIButton new];
//
//            msgBtn.frame = CGRectMake(JFA_SCREEN_WIDTH-50,20 , 35, 30);
//            msgBtn.layer.masksToBounds = YES;
//            msgBtn.layer.cornerRadius =17.5;
//
//            [msgBtn addTarget:self action:@selector(showMsg) forControlEvents:UIControlEventTouchUpInside];
//            msgBtn.backgroundColor = RGBACOLOR(225/225.0f, 225/225.0f, 225/225.0f, 0.6);
//            [msgBtn setImage:getImage(@"msg_") forState:UIControlStateNormal];
//            [headView addSubview:msgBtn];

            
        }
        else if (indexPath.section==1)
        {
            
        }
        else if (indexPath.section==2)
        {
            
        }
        else if(indexPath.section==3){
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/2-70, 15, 140, 18)];
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
    SearchResultViewController * se =[[SearchResultViewController alloc]init];
    [self.navigationController pushViewController:se animated:YES];
}
- (void)carouselView:(ADCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)didSelectItemAtIndex
{
    NSDictionary * dic = [self.bannerArray objectAtIndex:didSelectItemAtIndex-1];
    GoodsDetailViewController * gs = [[GoodsDetailViewController alloc]init];
    gs.hidesBottomBarWhenPushed = YES;
    gs.urlStr = [[dic safeObjectForKey:@"pathUrl"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.navigationController pushViewController:gs animated:YES];
}


-(void)showAdViewWithDict:(NSDictionary *)dict
{
    if (!adv) {
        adv = [[[NSBundle mainBundle]loadNibNamed:@"AdvertisingView" owner:nil options:nil]lastObject];
        adv.frame = self.view.bounds;
        adv.infoDict =[NSDictionary dictionaryWithDictionary:dict];
        [self.view addSubview:adv];
        [self.view bringSubviewToFront:adv];
        [adv setImageWithUrl:[dict safeObjectForKey:@"imgUrl"]];
    }

}
-(void)showADV:(NSNotification *)noti
{
    GoodsDetailViewController * de =[[GoodsDetailViewController alloc]init];
    de.urlStr = [noti.userInfo safeObjectForKey:@"pathUrl"];
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
