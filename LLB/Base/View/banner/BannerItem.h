//
//  BannerItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerItem : NSObject
@property (nonatomic ,copy  )NSString * content;   //商品id
@property (nonatomic ,copy  )NSString * imageUrl;  //图片路径
@property (nonatomic ,copy  )NSString * recommendName; // 展位名称
@property (nonatomic ,copy  )NSString * recommendID;  // 展位ID
@property (nonatomic ,assign)float      width;
@property (nonatomic ,assign)float      height;
@property (nonatomic ,assign)int        type;           // 内容类型：1.链接,2.商品
@property (nonatomic ,copy  )NSString * contentAmount;   //内容数量
@property (nonatomic ,assign)int        orders;
-(void)setBannerInfoWithDict:(NSDictionary *)dict;
@end
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
