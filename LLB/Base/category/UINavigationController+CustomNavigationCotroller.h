//
//  UINavigationController+CustomNavigationCotroller.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/31.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;
@end


@interface UINavigationController (CustomNavigationCotroller)<BackButtonHandlerProtocol>

@end
