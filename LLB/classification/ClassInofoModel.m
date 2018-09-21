//
//  ClassInofoModel.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/18.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "ClassInofoModel.h"

@implementation ClassInofoModel
-(NSString *)cellXibName
{
    return @"ClassInfoCollectionViewCell";
}
-(void)setInfoWithDict:(NSDictionary *)dict
{
    _imgUrl = [dict safeObjectForKey:@"classPicture"];
    _classId = [dict safeObjectForKey:@"id"];
    _titleStr = [dict safeObjectForKey:@"className"];
}

@end
