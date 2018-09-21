//
//  NSDictionary+JFASafeObject.m
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "NSDictionary+JFASafeObject.h"

@implementation NSDictionary (JFASafeObject)

-(id)safeObjectForKey:(id)key
{
    id result=[self objectForKey:key];
    
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return [result stringValue];
    }
    return result;
}


-(void)safeSetObject:(id)object key:(NSString *)key
{
    if (!object) {
        object=@"";
    }
    if (!key) {
        return;
    }
}
@end
