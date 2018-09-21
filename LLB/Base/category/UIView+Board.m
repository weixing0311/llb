//
//  UIView+Board.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/30.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UIView+Board.h"

@implementation UIView (Board)
-(void)setViewShadow
{
    self.layer.shadowColor = HEXCOLOR(0xcccccc).CGColor;
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowRadius = 4.f;
    self.layer.shadowOffset = CGSizeMake(2,2);
    self.layer.masksToBounds = NO;
    
//    self.layer.cornerRadius = self.userImage.frame.size.width / 2;
    
//    如果想要有点弧度的不是地球那么圆的可以设置
//    self.layer.cornerRadius =5;//这个值越大弧度越大
//    self.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色
//    
//    self.layer.borderWidth = .5;//边框宽度
}
@end
