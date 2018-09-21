//
//  UIView+LayerCustom.m
//  mama
//
//  Created by iOSdeveloper on 2017/9/13.
//  Copyright © 2017年 -call Me WeiXing. All rights reserved.
//

#import "UIView+LayerCustom.h"

@implementation UIView (LayerCustom)
-(void)setShardow
{
    self.layer.shadowColor = HEXCOLOR(0xcccccc).CGColor;
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowRadius = 14.f;
    self.layer.shadowOffset = CGSizeMake(2,2);
    self.layer.masksToBounds    = NO;
//    self.layer.cornerRadius     = 10;
    
}

@end
