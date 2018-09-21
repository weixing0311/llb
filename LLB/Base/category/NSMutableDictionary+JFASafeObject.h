//
//  NSMutableDictionary+JFASafeObject.h
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (JFASafeObject)

-(void)safeSetObject:(id)object forKey:(id<NSCopying>)key;

@end
