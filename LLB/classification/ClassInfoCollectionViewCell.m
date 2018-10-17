//
//  ClassInfoCollectionViewCell.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/18.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "ClassInfoCollectionViewCell.h"

@implementation ClassInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titlelb.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}
-(void)setModel:(ClassInofoModel *)model
{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    self.titlelb.text = model.titleStr;
}

@end
