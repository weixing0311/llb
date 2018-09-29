//
//  NSString+dateWithString.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (dateWithString)
-(NSString*)yyyymmdd;
-(NSString *)getdateCount;
-(NSString*)HHmm;
-(NSString*)mmdd;
-(NSString*)mmddhhmm;
-(NSDate *)dateyyyymmddhhmmss;
/**
 *计算时差
 */
+(NSString *)getNowTimeWithString:(NSString *)aTimeString;
///根据生日计算年龄
-(NSString *)getAge;
-(NSString *)getDateDay;

///当前时间戳
+(NSString *)getNowTimeTimestamp3;
@end
