//
//  UIImage+Extension.h
//  Pods
//
//  Created by 魏星 on 15/9/8.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)storeImageNamed:(NSString *)image;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

+ (UIImage*) createImageWithColor: (UIColor*) color;

+ (UIImage*) imageWithUIView:(UIView*) view;

- (UIImage *)scaledToSize:(CGSize)newSize;
@end
