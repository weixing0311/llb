//
//  UIImageView+Round.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/26.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Round)
typedef void (^success)( UIImage *image);
-(void)setMyImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder success:(success)success;
@end
