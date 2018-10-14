//
//  PublicGoodsCell.h
//  LLB
//
//  Created by iOSdeveloper on 2018/9/14.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseCollectionCell.h"

@interface PublicGoodsCell : BaseCollectionCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsStatelb;

@property (weak, nonatomic) IBOutlet UILabel *goodstitlelb;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@end
