//
//  BaseSerVice.h
//  mama
//
//  Created by iOSdeveloper on 2017/9/13.
//  Copyright © 2017年 -call Me WeiXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseSerVice : NSObject
+ (instancetype)sharedManager;
//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

-(NSString*)JFADomin;

-(id)getPostResponseSerSerializer;

-(id)getPostRequestSerializer;

-(id)getGetResponseSerSerializer;

-(id)getGetRequestSerializer;



-(NSURLSessionTask*)post:(NSString*)url
               paramters:(NSMutableDictionary *)paramters
                 success:(requestSuccessBlock)success
                 failure:(requestFailureBlock)failure;

-(NSURLSessionTask*)postImage:(NSString*)url
                    paramters:(NSMutableDictionary *)paramters
                    imageData:(NSData *)imageData
                    imageName:(NSString *)imageName//@"headimgurl.png"
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure;

-(NSURLSessionTask*)postBaiduImage:(NSString*)url
                         paramters:(NSMutableDictionary *)paramters
                         imageData:(NSData *)imageData
                         imageName:(NSString *)imageName//@"headimgurl.png"
                           success:(requestSuccessBlock)success
                           failure:(requestFailureBlock)failure;
-(NSURLSessionTask*)postBaidu:(NSString*)url
                    paramters:(NSMutableDictionary *)paramters
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure;

-(NSURLSessionTask*)getbaiduApiWithUrl:(NSString * )url
                               success:(requestSuccessBlock)success
                               failure:(requestFailureBlock)failure;
@end
