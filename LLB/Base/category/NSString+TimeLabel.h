//
//  NSString+TimeLabel.h
//  AppInstaller
//
//  Created by guowei on 3/30/12.
//  Copyright (c) 2014 iiApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeLabel)

+ (NSString *)formatDownloadSpeed:(double)speed;
+ (NSString *)formatTimeRemaining:(uint64_t)remaining;
+ (NSString *)formatRate:(double)download withTotal:(double)total;
+ (NSString *)formatSize:(double)size;
+ (NSString *)formatSizeWithoutSuffix:(double)size;
+ (NSString *)suffixForSize:(double)size;

- (NSTimeInterval)getTimeInterval;

@end
