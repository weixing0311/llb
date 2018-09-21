//
//  UIImage+Extension.m
//  Pods
//
//  Created by 魏星 on 15/9/8.
//
//

#import "UIImage+Extension.h"

#import "UIImage+LocalImage.h"

@implementation UIImage (Extension)

+ (UIImage *)storeImageNamed:(NSString *)image
{
    if ([image pathExtension].length == 0) {
        image = [image stringByAppendingPathExtension:@"png"];
    }
    
    UIImage * img = [UIImage imageNamed:[@"StoreResources.bundle/Images/" stringByAppendingPathComponent:image]];
    
    if (!img) {
        
        DLog(@"image is nil");
    }
    return img;
}

- (UIImage *)scaledToSize:(CGSize)newSize {
    //    //UIGraphicsBeginImageContext(newSize);
    //    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    //    // Pass 1.0 to force exact pixel size.
    //    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    //    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    //    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return newImage;
    
    
    CGFloat width = newSize.width;
    CGFloat height = newSize.height;
    CGFloat bitsPerComponent = CGImageGetBitsPerComponent(self.CGImage);
    CGFloat bytesPerRow = CGImageGetBytesPerRow(self.CGImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(self.CGImage);
    
    CGContextRef context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextDrawImage(context, CGRectMake(0,0,width,height), self.CGImage);
    
    return [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
}


+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


+ (UIImage*) imageWithUIView:(UIView*) view{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}


/**
 *颜色值转换成图片
 */

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return theImage;
}


@end
