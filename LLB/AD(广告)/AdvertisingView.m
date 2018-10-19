//
//  AdvertisingView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/30.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AdvertisingView.h"
#import "UIImageView+WebCache.h"
@implementation AdvertisingView
- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = RGBACOLOR(255/225.0f, 255/225.0f, 255/225.0f, .5);

    
    
}
- (IBAction)didCloseView:(id)sender {
    [self removeFromSuperview];
}
-(void)setImageWithUrl:(NSString * )imageUrl
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:getImage(@"default") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            self.imageView.image = image;
        }
    }];
    
    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.imageView.backgroundColor = HEXCOLOR(0x000000);

}
- (IBAction)showUrlPage:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kShowAdcPage" object:nil userInfo:self.infoDict];
    [self didCloseView:nil];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
