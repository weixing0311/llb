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

}








-(void)removeAllObject
{
    self.userId      = nil;
    self.token       = nil;
    self.nickName       = nil;
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [localPath  stringByAppendingPathComponent:@"UserInfo.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"文件abc.doc存在");
        NSError * error;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            DLog(@"删除本地文件error-%@",error);
        }
    }
    else {
        NSLog(@"文件abc.doc不存在");
    }


}
-(void)getUserInfoWithUserId:(NSString *)userId token:(NSString *)token
{
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:userId forKey:@"userId"];
    [params safeSetObject:token forKey:@"token"];
    [[BaseSerVice sharedManager]post:@""  hiddenHud:NO paramters:params success:^(NSDictionary *dic) {
        
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
-(void)getUpdateInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int  bundleVersion =[[infoDictionary objectForKey:@"CFBundleVersion"]intValue];
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(bundleVersion) forKey:@"code"];
    [params safeSetObject:@"2" forKey:@"source"];
    
    [[BaseSerVice sharedManager]post:@"api/isForce/judgeVersion.do" hiddenHud:YES paramters:params success:^(NSDictionary *dic) {
        DLog(@"更新信息————%@",dic);
        
        NSString * update = [NSString stringWithFormat:@"%@",[[dic safeObjectForKey:@"data"]objectForKey:@"isUpdate"]];
        if ([update isEqualToString:@"1"]) {
            [(AppDelegate *)[UIApplication sharedApplication].delegate showUpdateAlertViewWithMessage:[[dic safeObjectForKey:@"data"]objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}


@end
