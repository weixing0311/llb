//
//  PaySuccessViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/8/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BaseViewController.h"

@interface PaySuccessViewController : BaseViewController
@property (nonatomic,assign)int orderType;
@property (nonatomic,copy)NSString * orderUrl;
@property (nonatomic,assign)int paySuccess;
@end
