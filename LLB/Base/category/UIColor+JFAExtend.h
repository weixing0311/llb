//
//  UIColor+JFAExtend.h
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JFAExtend)

+ (UIColor *)colorForHex:(NSString *)hexColor;

+ (UIImage*)createImageWithColor:(UIColor*)color;

@end
