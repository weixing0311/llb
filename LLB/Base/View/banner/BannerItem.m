//
//  BannerItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BannerItem.h"

@implementation BannerItem
-(void)setBannerInfoWithDict:(NSDictionary *)dict
{
    /*
     "content": "1",
     "picture": "http://localhost:8080/img/tou.png",
     "height": 111,
     "recommendName": "导航页图片",
     "recommendID": 1,
     "width": 111,
     "type": 1,
     "contentAmount": 11,
     "orders": 1,
     */
    self.content       = [dict safeObjectForKey:@"content"];
    self.imageUrl      = [dict safeObjectForKey:@"picture"];
    self.width         = [[dict safeObjectForKey:@"width"]floatValue];
    self.height        = [[dict safeObjectForKey:@"height"]floatValue];
    self.recommendName = [dict safeObjectForKey:@"recommendName"];
    self.recommendID   = [dict safeObjectForKey:@"recommendID"];
    self.type          = [[dict safeObjectForKey:@"type"]intValue];
    self.contentAmount = [dict safeObjectForKey:@"contentAmount"];
    self.orders        = [[dict safeObjectForKey:@"orders"]intValue];
    
}
@end
