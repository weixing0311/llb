 //
//  UserModel.m
//  Yinli
//
//  Created by iOSdeveloper on 2017/9/25.
//  Copyright © 2017年 -call Me WeiXing. All rights reserved.
//

#import "UserModel.h"
#import <UIKit/UIKit.h>
static UserModel *model;
@implementation UserModel

+(UserModel *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[UserModel alloc]init];
    });
    return model;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //        self.child = [NSMutableArray array];
    }
    return self;
}
-(void)setInfoWithDic:(NSDictionary *)dict
{
    self.userId      = [dict safeObjectForKey:@"userId"];
    self.token       = [dict safeObjectForKey:@"token"];
    self.nickName       = [dict safeObjectForKey:@"name"];

//    self.waist       = [dict safeObjectForKey:@"waist"];
//    self.hipline       = [dict safeObjectForKey:@"hipline"];
//    self.identity       = [dict safeObjectForKey:@"identity"];
//    self.longLeg       = [dict safeObjectForKey:@"longLeg"];
//    self.shoulderWidth       = [dict safeObjectForKey:@"shoulderWidth"];
//    self.weight       = [dict safeObjectForKey:@"weight"];
//    self.birthday       = [dict safeObjectForKey:@"birthday"];
//    self.armLength       = [dict safeObjectForKey:@"armLength"];
//    self.height       = [dict safeObjectForKey:@"height"];
//    self.thigh       = [dict safeObjectForKey:@"thigh"];
//    self.isPerfect       = [dict safeObjectForKey:@"isPerfect"];
//    self.headImgUrl       = [dict safeObjectForKey:@"headImgUrl"];

    [self writeToDoc];
    
}
-(void)setInfoDictWithDict:(NSDictionary*)infoDict{
    self.infoDict = [NSDictionary dictionaryWithDictionary:infoDict];
    [self writeToDoc];
}
-(void)writeToDoc
{
    // NSDocumentDirectory 要查找的文件
    // NSUserDomainMask 代表从用户文件夹下找
    // 在iOS中，只有一个目录跟传入的参数匹配，所以这个集合里面只有一个元素
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict safeSetObject: self.userId     forKey:@"userId"];
    [dict safeSetObject:self.token forKey:@"token"];
    [dict safeSetObject:self.nickName forKey:@"nickName"];

//    [dict safeSetObject:self.infoDict forKey:@"infoDict"];
//    [dict safeSetObject:self.waist forKey:@"waist"];
//    [dict safeSetObject:self.hipline forKey:@"hipline"];
//    [dict safeSetObject:self.identity forKey:@"identity"];
//    [dict safeSetObject:self.longLeg forKey:@"longLeg"];
//    [dict safeSetObject:self.shoulderWidth forKey:@"shoulderWidth"];
//    [dict safeSetObject:self.weight forKey:@"weight"];
//    [dict safeSetObject:self.birthday forKey:@"birthday"];
//    [dict safeSetObject:self.armLength forKey:@"armLength"];
//    [dict safeSetObject:self.height forKey:@"height"];
//    [dict safeSetObject:self.thigh forKey:@"thigh"];
//    [dict safeSetObject:self.isPerfect forKey:@"isPerfect"];
//    [dict safeSetObject:self.headImgUrl forKey:@"headImgUrl"];


    
    
    
    
    
    
    
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"UserInfo.plist"];
    [dict writeToFile:filePath atomically:YES];
    
}
-(void)readToDoc
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *filePath = [path stringByAppendingPathComponent:@"UserInfo.plist"];
    // 解档
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    self.userId      = [dict safeObjectForKey:@"userId"];
    self.token       = [dict safeObjectForKey:@"token"];
    self.nickName       = [dict safeObjectForKey:@"nickName"];

//    self.infoDict    = [dict safeObjectForKey:@"infoDict"];
//    self.waist       = [dict safeObjectForKey:@"waist"];
//    self.hipline       = [dict safeObjectForKey:@"hipline"];
//    self.identity       = [dict safeObjectForKey:@"identity"];
//    self.longLeg       = [dict safeObjectForKey:@"longLeg"];
//    self.shoulderWidth       = [dict safeObjectForKey:@"shoulderWidth"];
//    self.weight       = [dict safeObjectForKey:@"weight"];
//    self.birthday       = [dict safeObjectForKey:@"birthday"];
//    self.armLength       = [dict safeObjectForKey:@"armLength"];
//    self.height       = [dict safeObjectForKey:@"height"];
//    self.thigh       = [dict safeObjectForKey:@"thigh"];
//    self.isPerfect       = [dict safeObjectForKey:@"isPerfect"];
//    self.headImgUrl       = [dict safeObjectForKey:@"headImgUrl"];

}








-(void)removeAllObject
{
    self.userId      = nil;
    self.token       = nil;
    self.nickName       = nil;

//    self.infoDict    = nil;
//    self.waist       = nil;
//    self.hipline       = nil;
//    self.identity       = nil;
//    self.longLeg       = nil;
//    self.shoulderWidth       = nil;
//    self.weight       = nil;
//    self.birthday       = nil;
//    self.armLength       = nil;
//    self.height       = nil;
//    self.thigh       = nil;
//    self.isPerfect       = nil;
//    self.headImgUrl       = nil;

}
-(void)getUserInfoWithUserId:(NSString *)userId token:(NSString *)token
{
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:userId forKey:@"userId"];
    [params safeSetObject:token forKey:@"token"];
    [[BaseSerVice sharedManager]post:@"" paramters:params success:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(id)getXibCellWithTitle:(NSString *)title
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:title owner:nil options:nil];
    if (arr) {
        return [arr lastObject];
        
    }else{
        return nil;
    }
}
-(void)showSuccessWithStatus:(NSString *)status
{
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showSuccessWithStatus:status];
}
-(void)showErrorWithStatus:(NSString *)status
{
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showErrorWithStatus:status];
}
-(void)showInfoWithStatus:(NSString *)status
{
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showInfoWithStatus:status];
}
-(void)dismiss
{
    [SVProgressHUD dismiss];
}


@end
