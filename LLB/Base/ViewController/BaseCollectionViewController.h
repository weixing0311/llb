//
//  BaseCollectionViewController.h
//  LLB
//
//  Created by iOSdeveloper on 2018/9/14.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseCollectionCell.h"
#import "BaseCellModel.h"

@interface BaseCollectionViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)  UICollectionViewFlowLayout *layout;
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (nonatomic,strong)   NSDictionary * infoDict;
@property (nonatomic,strong)   NSMutableArray * dataArray;
@property (nonatomic,assign)   int  page;
@property (nonatomic,assign)   NSInteger sectionCount;
-(void)setRefrshWithCollectionView:(UICollectionView *)co;
//-(void)setExtraCellLineHiddenWithTb:(UITableView *)tb;
-(void)headerRereshing;
-(void)footerRereshing;
///设置item尺寸
-(CGSize)setCollectionViewItemSizeWithSection:(NSInteger)section;

///设置head尺寸
-(CGSize)setCollectionViewHeaderSizeWithSection:(NSInteger)section;

///点击item
-(void)didClickItemWithIndexPath:(NSIndexPath *)indexPath;


///创建headView
-(UIView*)createHeaderViewWithInfo:(NSDictionary *)infoDict indexPath:(NSIndexPath *)indexPath;
///重写collectionViewCellIndexpathForItem
-(BaseCollectionCell *)createItemWithIndexPath:(NSIndexPath *)indexPath;


-(NSInteger)numberOfRowsInSection:(NSInteger)section;
-(NSInteger)sectionCount;

-(void)getDataInfo;
-(void)setCollectionViewHead;
-(void)setCollectionViewCell;
@end
