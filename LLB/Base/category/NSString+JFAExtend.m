//
//  NSString+JFAExtend.m
//  JFABaseKit
//
//  Created by stefan on 15/8/28.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "NSString+JFAExtend.h"
#import <CommonCrypto/CommonDigest.h>
#define MD5_LENGTH 16

@implementation NSString (JFAExtend)

- (CGFloat)heightForLabelWithWidth:(CGFloat)isWidth isFont:(UIFont*)labelFont{
    CGFloat height = 0.0f;
//    height = ceilf([self sizeWithFont:labelFont constrainedToSize:CGSizeMake(isWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height);
    NSDictionary *attribute = @{NSFontAttributeName: labelFont};
    height = [self boundingRectWithSize:CGSizeMake(isWidth, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
    return height;
}

- (CGFloat)heightForLabelWithWidth:(CGFloat)isWidth isTextFont:(CGFloat)isTextFont{
    return [self heightForLabelWithWidth:isWidth isFont:[UIFont systemFontOfSize:isTextFont]];
}

- (CGFloat)widthForLabelWithHeight:(CGFloat)isHeight isTextFont:(CGFloat)isTextFont {

    return [self widthForLabelWithHeight:isHeight isFont:[UIFont systemFontOfSize:isTextFont]];
}

- (CGFloat)widthForLabelWithHeight:(CGFloat)isHeight isFont:(UIFont*)font {
    CGFloat width = 0.0f;
//    width = ceilf([self sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, isHeight) lineBreakMode:NSLineBreakByWordWrapping].width);
    NSDictionary *attribute = @{NSFontAttributeName: font};
    width = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, isHeight) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.width;
    return width;
}
-(NSString*)md5String
{
    int i = 0;
    NSMutableString *cryptedString = [[NSMutableString alloc] initWithCapacity:MD5_LENGTH];
    unsigned char result[MD5_LENGTH];
    const char *string = [self UTF8String];
    CC_MD5(string, strlen(string), result);
    for (i = 0; i < MD5_LENGTH; ++i) {
        [cryptedString appendFormat:@"%02X", result[i]];
    }
    return [cryptedString lowercaseString];
}
- (CGSize)sizeWithTheFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize textSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        textSize = [self boundingRectWithSize:size
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil].size;
    }else{
        NSDictionary *attribute = @{NSFontAttributeName: font};
        textSize = [self boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//        textSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:0];
    }
    return textSize;
}

typedef struct StepInfo{
    uint32_t oneStep;
    uint32_t twoStep;
    uint32_t threeStep;
} StepInfo;

+ (StepInfo) stepInfo:(uint64_t)total withstep:(uint32_t)step
{
    StepInfo stepInfo = {0,0,0};
    stepInfo.threeStep = (uint32_t)(total/(step*step));
    stepInfo.twoStep = (uint32_t)((total-(stepInfo.threeStep*step*step))/step);
    stepInfo.oneStep = (uint32_t)(total-(stepInfo.threeStep*step*step)-(stepInfo.twoStep*step));
    return stepInfo;
}

+ (NSString*)formatDownloadSpeed:(double)speed
{
    NSString *downloadSpeed = @"";
    StepInfo step = [self stepInfo:speed withstep:1024];
    if (step.threeStep > 0) {
        downloadSpeed = [NSString stringWithFormat:@"%uMB/S", (uint32_t)step.threeStep];
    }else if(step.twoStep > 0){
        downloadSpeed = [NSString stringWithFormat:@"%uKB/S", (uint32_t)step.twoStep];
    }else if(step.oneStep > 0){
        downloadSpeed = [NSString stringWithFormat:@"%uB/S", (uint32_t)step.oneStep];
    }
    return downloadSpeed;
}



@end
