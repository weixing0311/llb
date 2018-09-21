//
//  BaseTableViewController.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/14.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableViewCell.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page =1;

    // Do any additional setup after loading the view.
}
-(void)buildTableView
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = HEXCOLOR(0xeeeeee);
        _tableview.separatorColor = HEXCOLOR(0xeeeeee);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setExtraCellLineHiddenWithTb:_tableview];
        [self.view addSubview:_tableview];
    }
}
-(void)setExtraCellLineHiddenWithTb:(UITableView *)tb
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = HEXCOLOR(0xeeeeee);
    [tb setTableFooterView:view];
}
-(void)setRefrshWithTableView:(UITableView *)tb
{
    
    tb.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    tb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [tb.mj_header beginRefreshing];
    
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
-(float)cellHeightWithIndexPath:(NSIndexPath *)indexPath
{
    return 0.00;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return _titleStr;
//}
#pragma mark ----tableviewdelegate  datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightWithIndexPath:indexPath];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellModel * model = [_dataArray objectAtIndex:indexPath.row];
    
    NSString * cellIdentification=[model cellXibName]?[model cellXibName]:[model cellClassName];
    
    BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self didSelectTbWithIndexPath:indexPath];
}
-(void)didSelectTbWithIndexPath:(NSIndexPath*)indexPath
{
    
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
