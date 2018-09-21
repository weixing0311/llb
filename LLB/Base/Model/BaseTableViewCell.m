//
//  BaseTableViewCell.m
//  Yinli
//
//  Created by iOSdeveloper on 2018/1/4.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(BaseCellModel *)model
{
    
}
-(void)setIndexCount:(NSInteger)indexCount
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
