//
//  BaseTableViewController.h
//  LLB
//
//  Created by iOSdeveloper on 2018/9/14.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)int  page;
-(void)buildTableView;
-(void)setExtraCellLineHiddenWithTb:(UITableView *)tb;
-(void)setRefrshWithTableView:(UITableView *)tb;
-(void)headerRereshing;
-(void)footerRereshing;
-(void)didSelectTbWithIndexPath:(NSIndexPath*)indexPath;
-(float)cellHeightWithIndexPath:(NSIndexPath *)indexPath;

@end
