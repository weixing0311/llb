//
//  BaseViewController.h
//  Yinli
//
//  Created by iOSdeveloper on 2017/9/25.
//  Copyright © 2017年 -call Me WeiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellModel.h"

@interface BaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSString * titleStr;
-(id)getXibCellWithTitle:(NSString *)title;

-(void)showEmptyViewWithTitle:(NSString *)title;
-(void)hiddenEmptyView;
-(void)refreshEmptyView;

-(NSString*)DataTOjsonString:(id)object;
//字典转model
-(NSMutableArray *)getModelWithArray:(NSArray *)infoArr model:(NSString *)modelStr;
@end
