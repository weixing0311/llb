//
//  BaseCellModel.h
//  Yinli
//
//  Created by iOSdeveloper on 2018/1/4.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCellModel : NSObject
-(NSString *)cellXibName;
-(NSString *)cellClassName;
-(void)setInfoWithDict:(NSDictionary *)dict;
@end
