//
//  PublicGoodsCell.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/14.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "PublicGoodsCell.h"

@implementation PublicGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyBtn.layer.borderWidth = 1;
    self.buyBtn.layer.borderColor = [UIColor redColor].CGColor;
    // Initialization code
}

- (IBAction)didbuy:(id)sender {
}
@end
