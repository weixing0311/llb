//
//  AdvertisingView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/8/30.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol adVertisingDelegate;
@interface AdvertisingView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
-(void)setImageWithUrl:(NSString * )imageUrl;
@property (nonatomic,strong)NSDictionary * infoDict;
@end


