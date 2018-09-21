//
//  NSDate+CustomDate.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CustomDate)
-(NSString*)yyyymmddhhmmss;
-(NSString *)yyyymmdd;
-(NSString*)mmddhhmm;
-(NSString*)mmdd;
//根据生日计算年龄
-(NSString *)getAge;
@end
