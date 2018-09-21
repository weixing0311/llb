//
//  NSString+Extension.h
//  开店通
//
//  Created by 张浩 on 15/7/6.
//  Copyright (c) 2015年 张浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RSA)
/**
 *  字符串进行RSA加密
 *
 *  @param string 需要进行加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encryptString:(NSString *)string;
@end
