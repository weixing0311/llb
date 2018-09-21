//
//  NSString+Extension.m
//  开店通
//
//  Created by 张浩 on 15/7/6.
//  Copyright (c) 2015年 张浩. All rights reserved.
//

#import "NSString+RSA.h"
#import "RSA.h"

@implementation NSString (RSA)

+ (NSString *)encryptString:(NSString *)string
{
    // 加密时使用的公钥
    NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDAMjG7ZtGL+Mr43zcQCnPo/VVrD9iEhdr2l6/c4fUmgsiWQ1nQ18oPFLB2R26lY7wM3BdHSPlTejtKIvfp4f+GS7NEzL/TruM2s3G6JwSUH+D6EwHH1Co+4qR6JbUJdzkVmXbuSZdTsiViLO9vC6SdJN8cMmBRZj93YojXjk+T2wIDAQAB";
    
    NSString *ret = [RSA encryptString:string publicKey:publicKey];
    
    return ret;
}
@end
