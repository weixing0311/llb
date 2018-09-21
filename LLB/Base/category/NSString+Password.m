//
//  NSString+Password.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/30.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NSString+Password.h"

@implementation NSString (Password)
-(BOOL)checkPassWord
{
    //6-20位数字和字母组成
    NSString *regex = @"^[A-Za-z0-9]{1,15}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:self]) {
        return YES ;
    }else
        return NO;
}
@end
