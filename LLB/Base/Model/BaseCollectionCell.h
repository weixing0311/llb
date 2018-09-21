//
//  BaseCollectionCell.h
//  LLB
//
//  Created by iOSdeveloper on 2018/9/14.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellModel.h"
@interface BaseCollectionCell : UICollectionViewCell
@property (nonatomic,strong)BaseCellModel * model;
@property (nonatomic,assign)NSInteger indexCount;

@end
