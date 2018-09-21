//
//  UserModel.h
//  Yinli
//
//  Created by iOSdeveloper on 2017/9/25.
//  Copyright © 2017年 -call Me WeiXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
+(UserModel *)shareInstance;



@property(nonatomic,copy) NSString * access_token;

@property (nonatomic,copy) NSString * waist;
@property (nonatomic,copy) NSString * hipline;
@property (nonatomic,copy) NSString * identity;
@property (nonatomic,copy) NSString * nickName;
@property (nonatomic,copy) NSString * longLeg;
@property (nonatomic,copy) NSString * shoulderWidth;
@property (nonatomic,copy) NSString * weight;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * token;
@property (nonatomic,copy) NSString * birthday;
@property (nonatomic,copy) NSString * armLength;
@property (nonatomic,copy) NSString * height;
@property (nonatomic,copy) NSString * thigh;

@property (nonatomic,copy) NSString * headImgUrl;
@property (nonatomic,copy) NSString * isPerfect;




-(void)writeToDoc;



@property (nonatomic,strong)NSDictionary * infoDict;
-(void)setInfoWithDic:(NSDictionary *)dict;
-(void)setInfoDictWithDict:(NSDictionary*)infoDict;
-(void)readToDoc;
-(id)getXibCellWithTitle:(NSString *)title;
-(void)showSuccessWithStatus:(NSString *)status;
-(void)showErrorWithStatus:(NSString *)status;
-(void)showInfoWithStatus:(NSString *)status;
-(void)dismiss;
-(void)removeAllObject;
@end
