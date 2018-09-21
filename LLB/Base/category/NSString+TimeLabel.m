//
//  NSString+TimeLabel.m
//  AppInstaller
//
//  Created by guowei on 3/30/12.
//  Copyright (c) 2014 iiApple. All rights reserved.
//

#import "NSString+TimeLabel.h"

typedef struct StepInfo{
    uint32_t oneStep;
    uint32_t twoStep;
    uint32_t threeStep;
} StepInfo;

@implementation NSString (TimeLabel)

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

+ (NSString*)formatTimeRemaining:(uint64_t)remaining
{
    NSString *timeRemaining = @"";
    if (remaining == 0) {
        return @"0秒";
    }
    
    StepInfo step = [self stepInfo:remaining withstep:60];
    if (step.threeStep > 0) {
        timeRemaining = [timeRemaining stringByAppendingFormat:@"%u小时", (uint32_t)step.threeStep];
    }
    if (step.twoStep > 0) {
        timeRemaining = [timeRemaining stringByAppendingFormat:@"%u分", (uint32_t)step.twoStep];
    }
    if (step.oneStep > 0) {
        uint32_t seconds = (uint32_t)step.oneStep;
        timeRemaining = [timeRemaining stringByAppendingFormat:@"%u秒", seconds == 0?1 : seconds];
    }
    return timeRemaining;
}

+ (NSString*)formatRate:(double)download withTotal:(double)total
{
    StepInfo step = [self stepInfo:total withstep:1024];
    if (step.threeStep > 0) {
        return [NSString stringWithFormat:@"%u/%1.1fMB",(uint32_t)(download/(1024*1024)), total / 1024 / 1024]; 
    }else if(step.twoStep > 0){
        return [NSString stringWithFormat:@"%u/%1.1fKB",(uint32_t)(download/1024), total / 1024];
    }else if(step.oneStep > 0){
       return [NSString stringWithFormat:@"%u/%1.1fB",(uint32_t)download, total]; 
    }
    
    return nil;
}

+ (NSString *)formatSize:(double)size;
{
    StepInfo step = [self stepInfo:size withstep:1024];
    if (step.threeStep > 0) {
        return [NSString stringWithFormat:@"%1.1f MB", size / 1024 / 1024];
    } else if(step.twoStep > 0){
        return [NSString stringWithFormat:@"%1.1f KB", size / 1024];
    }else if(step.oneStep > 0){
        return [NSString stringWithFormat:@"%1.1f B", size];
    }
    
    return @"0 KB";
}

+ (NSString *)formatSizeWithoutSuffix:(double)size
{
    StepInfo step = [self stepInfo:size withstep:1024];
    if (step.threeStep > 0) {
        return [NSString stringWithFormat:@"%1.1f", size / 1024 / 1024];
    } else if(step.twoStep > 0){
        return [NSString stringWithFormat:@"%1.1f", size / 1024];
    }else if(step.oneStep > 0){
        return [NSString stringWithFormat:@"%f", size];
    }
    
    return @"0";
}
+ (NSString *)suffixForSize:(double)size
{
    StepInfo step = [self stepInfo:size withstep:1024];
    if (step.threeStep > 0) {
        return @"MB";
    } else if(step.twoStep > 0){
        return @"KB";
    }else if(step.oneStep > 0){
        return @"B";
    }
    
    return @"KB";
}

- (NSTimeInterval)getTimeInterval
{
    NSDateFormatter* format=[[NSDateFormatter alloc]init];
    
    NSDate* date=[format dateFromString:self];
    
    return [date timeIntervalSince1970];

}
@end
