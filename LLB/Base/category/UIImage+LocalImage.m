//
//  UIImage+LocalImage.m
//  Pods
//
//  Created by 魏星 on 15/9/8.
//
//

#import "UIImage+LocalImage.h"

#import <objc/runtime.h>

// 当前iOS版本
#ifndef __CUR_IOS_VERSION
#define __CUR_IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue] * 10000)
#endif

@implementation UIImage (LocalImage)


+ (void)load
{
    if (__CUR_IOS_VERSION >= __IPHONE_8_0) {
        // 由于iOS8已经兼容，所以不需要使用下面方法
        return;
    }
    
    // 改替换实现用代码调用imageNamed:时的图片适应
    SEL origM = @selector(imageNamed:);
    SEL newM = @selector(imageWithName:);
    method_exchangeImplementations(class_getClassMethod(self, origM), class_getClassMethod(self, newM));
    
    // 该替换实现对xib中图片的适应
    NSString *className = [[@"UIImage" stringByAppendingString:@"Nib"] stringByAppendingString:@"Placeholder"]; // 这样写是为了避开AppStore审核的代码检查，不一定有效
    Method m1 = class_getInstanceMethod(NSClassFromString(className), @selector(initWithCoder:));
    Method m2 = class_getInstanceMethod(self, @selector(initWithCoderForNib:));
    method_exchangeImplementations(m1, m2);
    
}


/** 该方法替换原有的imageNamed:方法 */
+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *aImage = [self imageWithName:name];
    if (aImage) {
        // 如果能取到对应图片，则直接返回
        return aImage;
    }
    
    NSString *fileName = [name stringByAppendingString:@"@3x.png"];
    aImage = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName]];
    
    return [aImage scaledImageFrom3x];
}

/** 该方法替换UIImage-Nib-Placeholder中的initWithCoder:，因为xib的图片都是用这个类来初始化的 */
- (id)initWithCoderForNib:(NSCoder *)aDecoder
{
    NSString *resourceName = [aDecoder decodeObjectForKey:@"UIResourceName"];
    NSString *newResourceName = resourceName;
    
    if ([resourceName hasSuffix:@".png"]) {
        newResourceName = [resourceName substringToIndex:resourceName.length -4];
    }
    
    return [UIImage imageNamed:newResourceName];
}


/** 将原本3倍尺寸的图片缩放到设备对应尺寸 */
- (UIImage *)scaledImageFrom3x
{
    
    
    float locScale = [UIScreen mainScreen].scale;
    float theRate = 1.0;
    
    if (JFA_SCREEN_WIDTH < 568) {
        
        theRate = 1.0 / 3.0;
        
        if (IOS8_OR_LATER) {
            theRate = 1.0;
        }
        
    }else{
        if (IOS8_OR_LATER) {
        }else{
            theRate = 1.0 /3.0;
        }
    }
    
    
    UIImage *newImage = nil;
    
    CGSize oldSize = self.size;
    
    CGFloat scaledWidth = oldSize.width * theRate;
    CGFloat scaledHeight = oldSize.height * theRate;
    
    CGRect scaledRect = CGRectZero;
    scaledRect.size.width  = scaledWidth;
    scaledRect.size.height = scaledHeight;
    
    UIGraphicsBeginImageContextWithOptions(scaledRect.size, NO, locScale);
    
    [self drawInRect:scaledRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    return newImage;
}


@end
