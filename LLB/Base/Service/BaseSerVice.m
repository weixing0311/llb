//
//  BaseSerVice.m
//  mama
//
//  Created by iOSdeveloper on 2017/9/13.
//  Copyright © 2017年 -call Me WeiXing. All rights reserved.
//

#import "BaseSerVice.h"
#import "AppDelegate.h"
//#import "AppDelegate.h"
@implementation BaseSerVice
{
    AFHTTPSessionManager* manager;
}
+ (instancetype)sharedManager {
    static BaseSerVice *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 请求超时设定
        manager=[AFHTTPSessionManager manager];
        manager.responseSerializer=[self getPostResponseSerSerializer];
        manager.requestSerializer=[self getPostRequestSerializer];
        
        manager.requestSerializer.timeoutInterval = 15;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        manager.securityPolicy.allowInvalidCertificates = NO;
    }
    return self;
}
-(NSString*)JFADomin
{
    return kMyBaseUrl;
}

-(id)getPostResponseSerSerializer
{
    return [AFHTTPResponseSerializer serializer];
}

-(id)getPostRequestSerializer
{
    return [AFHTTPRequestSerializer serializer];
}
-(NSURLSessionTask*)post:(NSString*)url
               paramters:(NSMutableDictionary *)paramters
                 success:(requestSuccessBlock)success
                 failure:(requestFailureBlock)failure
{
    ////去掉Url中误入的空格
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    [manager.requestSerializer setValue:[UserModel shareInstance].userId?[UserModel shareInstance].userId:@"" forHTTPHeaderField:@"userId"];
//    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:[UserModel shareInstance].token?[UserModel shareInstance].token:@"" forHTTPHeaderField:@"token"];
//    [manager.requestSerializer setValue:[[UserModel shareInstance] getVersion] forHTTPHeaderField:@"version"];
    DLog(@"request.Url-%@",[NSString stringWithFormat:@"%@%@",[self JFADomin],url]);
    
    [paramters safeSetObject:[UserModel shareInstance].token forKey:@"token"];
    
    
   NSString * urlString = [[NSString stringWithFormat:@"%@%@",[self JFADomin],url] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
    

    
    NSURLSessionTask * task = [manager POST:urlString parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [SVProgressHUD dismiss];
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        
        NSString * statusStr =[dic safeObjectForKey:@"status"];
        int  code =[[dic safeObjectForKey:@"code"]intValue];
        DLog(@"%@--%@--%@--%@",dic ,[dic objectForKey:@"code"],[dic objectForKey:@"message"],[NSString stringWithFormat:@"%@%@",[self JFADomin],url]);
        
        
        if (code  ==601) {//登录失效
            [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];

            [SVProgressHUD dismiss];
            
        }else{
            if (code==602) {//登录失效
                
            }else{
                
                if (statusStr&&[statusStr isEqualToString:@"success"]) {
                    success(dic);
                }else{
                    
                    NSError * error = [[NSError alloc]initWithDomain:NSURLErrorDomain code:[[dic objectForKey:@"code"]intValue] userInfo:dic];
                    [[UserModel shareInstance]showInfoWithStatus:[dic objectForKey:@"message"]];

                    failure(error);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"error--%ld-%@",(long)error.code,[error.userInfo safeObjectForKey:@"NSLocalizedDescription"]);
        
        if ([error code] ==-1009) {
            [[UserModel shareInstance] showInfoWithStatus:@"连接失败，请检查网络"];
            
        }
        
        if ([error code] ==-1001) {
            [[UserModel shareInstance] showInfoWithStatus:@"连接失败，请检查网络"];
        }
        if ([error code]==-1011) {
            [[UserModel shareInstance]showInfoWithStatus:@"页面丢失--404"];
        }
        failure(error);
    }];    return task;
}


-(NSURLSessionTask*)postImage:(NSString*)url
                    paramters:(NSMutableDictionary *)paramters
                    imageData:(NSData *)imageData
                    imageName:(NSString *)imageName//@"headimgurl.png"
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure
{
    if (!manager) {
        manager =[AFHTTPSessionManager manager];
    }
    [manager.requestSerializer setValue:[UserModel shareInstance].userId?[UserModel shareInstance].userId:@"" forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:[UserModel shareInstance].token?[UserModel shareInstance].token:@"" forHTTPHeaderField:@"token"];
//    [manager.requestSerializer setValue:[[UserModel shareInstance] getVersion] forHTTPHeaderField:@"version"];
    
    [SVProgressHUD show];
    
    NSURLSessionTask * task =[manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData&&imageData.length>1) {
            [formData appendPartWithFileData:imageData name:imageName fileName:[NSString stringWithFormat:@"%@.png",imageName] mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        [SVProgressHUD showProgress:uploadProgress.localizedDescription status:@"Loading"];
        
        DLog(@"上传进度--%@",uploadProgress.localizedDescription);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        
        NSString * statusStr =[dic safeObjectForKey:@"status"];
        DLog(@"%@--%@--url-%@",dic ,[dic objectForKey:@"message"],url);
        int  code =[[dic safeObjectForKey:@"code"]intValue];
        
        
        if (code  ==601) {//登录失效
//            [SVProgressHUD dismiss];
            [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
        }else{
            if (code==602) {//登录失效
//                [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
                
            }else{
                if (statusStr&&[statusStr isEqualToString:@"success"]) {
                    success(dic);
                }else{
                    [[UserModel shareInstance] showInfoWithStatus:[dic objectForKey:@"message"]];
                    NSError * error = [[NSError alloc]initWithDomain:NSURLErrorDomain code:[[dic objectForKey:@"code"]intValue] userInfo:dic];
                    
                    failure(error);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([error code] ==-1005) {
            [[UserModel shareInstance] showErrorWithStatus:@"连接失败，请检查网络"];
        }
        DLog(@"error--%ld-%@--url--%@",(long)error.code,[error.userInfo safeObjectForKey:@"NSLocalizedDescription"],url);

        failure(error);
        
    }];
    
    return task;

}



-(NSURLSessionTask*)postBaidu:(NSString*)url
                paramters:(NSMutableDictionary *)paramters
                  success:(requestSuccessBlock)success
                  failure:(requestFailureBlock)failure
{
    DLog(@"request.Url-%@",[NSString stringWithFormat:@"%@",url]);
    
    
    NSURLSessionTask * task = [manager POST:[NSString stringWithFormat:@"%@",url] parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        DLog(@"dic--%@",dic);
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
    return task;
}
-(NSURLSessionTask*)postBaiduImage:(NSString*)url
                    paramters:(NSMutableDictionary *)paramters
                    imageData:(NSData *)imageData
                    imageName:(NSString *)imageName//@"headimgurl.png"
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure
{
    if (!manager) {
        manager =[AFHTTPSessionManager manager];
    }
    
    [SVProgressHUD show];
    
    NSURLSessionTask * task =[manager POST:[NSString stringWithFormat:@"%@",url] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData&&imageData.length>1) {
            [formData appendPartWithFileData:imageData name:imageName fileName:[NSString stringWithFormat:@"%@.png",imageName] mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        DLog(@"上传进度--%@",uploadProgress.localizedDescription);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        
        NSString * statusStr =[dic safeObjectForKey:@"status"];
        DLog(@"%@--%@",dic ,[dic objectForKey:@"message"]);
        
        if (statusStr&&[statusStr isEqualToString:@"success"]) {
            success(dic);
        }else{
            
            NSError * error = [[NSError alloc]initWithDomain:NSURLErrorDomain code:[[dic objectForKey:@"code"]intValue] userInfo:dic];
            failure(error);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([error code] ==-1005) {
            [[UserModel shareInstance] showErrorWithStatus:@"连接失败，请检查网络"];
        }
        failure(error);
        
    }];
    
    return task;
}
- (NSDictionary *)dictionaryWithData:(NSData*)data {
    
    if (!data) {
        return nil;
    }
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
-(NSURLSessionTask*)getbaiduApiWithUrl:(NSString * )url success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    NSURLSessionTask * task = [manager POST:[NSString stringWithFormat:@"%@",url] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        DLog(@"dic---%@",dic);
        
        success(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"error--%ld-%@",(long)error.code,[error.userInfo safeObjectForKey:@"NSLocalizedDescription"]);
        
        failure(error);
    }];
    return task;

}
@end
