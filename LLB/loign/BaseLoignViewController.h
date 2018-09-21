//
//  BaseLoignViewController.h
//  LLB
//
//  Created by iOSdeveloper on 2018/9/18.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseLoignViewController : BaseViewController
-(void)getUserInfoWithUserId:(NSString *)userId token:(NSString *)token;
-(void)didLoignLastWithType:(NSString *)type content:(NSString *)content msm:(NSString *)msm;
@end
