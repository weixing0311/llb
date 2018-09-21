//
//  UIView+JFAViewAnimation.m
//  Pods
//
//  Created by stefan on 15/8/28.
//
//

#import "UIView+JFAViewAnimation.h"

@implementation UIView (JFAViewAnimation)

- (void)continueRotateAnimation
{
    if (![self.layer animationForKey:@"rotate"]){
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1.8;
        rotationAnimation.repeatCount = FLT_MAX;
        rotationAnimation.cumulative = NO;
        [self.layer addAnimation:rotationAnimation forKey:@"rotate"];
    }
}


- (void)stopRotateAnimation{
    [self.layer removeAnimationForKey:@"rotate"];
}

@end
