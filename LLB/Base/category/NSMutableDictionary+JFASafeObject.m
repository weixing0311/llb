//
//  NSMutableDictionary+JFASafeObject.m
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "NSMutableDictionary+JFASafeObject.h"

@implementation NSMutableDictionary (JFASafeObject)
-(void)safeSetObject:(id)object forKey:(id<NSCopying>)key
{
    if (object==nil) {
        DLog(@"error : key=nil （%@）",key);
        return;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        DLog(@"error : key=NUll （%@）",key);
        return;
    }
    [self setObject:object forKey:key];
}
@end
