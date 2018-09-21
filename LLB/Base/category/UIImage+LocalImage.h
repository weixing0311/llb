//
//  UIImage+LocalImage.h
//  Pods
//
//  Created by 魏星 on 15/9/8.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (LocalImage)
/** 将原本3倍尺寸的图片缩放到设备对应尺寸 */
- (UIImage *)scaledImageFrom3x;


@end
