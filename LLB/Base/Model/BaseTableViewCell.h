//
//  BaseTableViewCell.h
//  Yinli
//
//  Created by iOSdeveloper on 2018/1/4.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellModel.h"

@interface BaseTableViewCell : UITableViewCell
@property (nonatomic,strong)BaseCellModel * model;
@property (nonatomic,assign)NSInteger indexCount;
@end
