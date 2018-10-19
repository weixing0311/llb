//
//  AppDelegate.m
//  LLB
//
//  Created by iOSdeveloper on 2018/9/13.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "AppDelegate.h"
#import "LoignViewController.h"
#import "FirstTabbarViewController.h"
#import "PaySuccessViewController.h"
#import "UpdateViewController.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate
{
    LoignViewController * lo;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self remoViewCookies];
   BOOL resignVx = [WXApi registerApp:kWeixinKey withDescription:@"lilibang_ios_wx"];
    
    if (resignVx ==YES) {
        DLog(@"微信注册成功");
    }else{
        DLog(@"微信注册失败");
    }
    [[UserModel shareInstance]readToDoc];
    
    [[UserModel shareInstance]getUpdateInfo];
    FirstTabbarViewController * fs =[[FirstTabbarViewController alloc]init];
    [self.window setRootViewController:fs];



    
    return YES;
}
-(void)loignOut
{
    [[UserModel shareInstance]removeAllObject];
    
    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"警告" message:@"有人在其他设备登录您的账号，本设备将会强制退出。如果这不是您本人操作，请立刻通过登录页面找回密码功能修改密码，慎防盗号。" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [al addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (!lo) {
            lo = [[LoignViewController alloc]initWithNibName:@"LoignViewController" bundle:nil];
            UINavigationController *  nav = [[UINavigationController alloc]initWithRootViewController:lo];
            [self.window setRootViewController:nav];
            
        }else{
            UINavigationController *  nav = [[UINavigationController alloc]initWithRootViewController:lo];
            
            [self.window setRootViewController:nav];
        }
    }]];
    [self.window.rootViewController presentViewController:al animated:YES completion:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([url.absoluteString isEqualToString:@"app.wwogou.com://"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshWXPayWebView" object:nil];
        return YES;
    }
    
    return  [WXApi handleOpenURL:url delegate:self];
}
-(void)onReq:(BaseReq *)req
{
    
}
-(void)onResp:(BaseResp *)resp
{
    DLog(@"微信返回---%@",resp);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp * rsp = (SendAuthResp*)resp;
        if (rsp.errCode ==0) {
            DLog(@"登录成功！！！！");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"wxloignSuccess" object:nil userInfo:@{@"code":rsp.code}];
        }
    }
}


-(void)showUpdateAlertViewWithMessage:(NSString *)message
{
    
    UpdateViewController * up = [[UpdateViewController alloc]init];
    
    [self.window.rootViewController addChildViewController:up];
    [up didMoveToParentViewController:self.window.rootViewController];
    up.view.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    up.contentTextView.text = message;
    [self.window.rootViewController.view addSubview:up.view];

    
//    if ([UserModel shareInstance].isUpdate==YES) {
//
//        UIAlertController * la =[UIAlertController alertControllerWithTitle:@"有新版本需要更新" message:[UserModel shareInstance].updateMessage preferredStyle:UIAlertControllerStyleAlert];
//
//        [la addAction:[UIAlertAction actionWithTitle:@"跳转到AppStore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1209417912"]];
//        }]];
//
//        if ([UserModel shareInstance].isForce==0) {
//            [la addAction:[UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [UserModel shareInstance].ignoreVerSion = [UserModel shareInstance].upDataVersion;
//                [[NSUserDefaults standardUserDefaults]setObject:@([UserModel shareInstance].ignoreVerSion) forKey:@"ignoreVerSion"];
//
//                [UserModel shareInstance].isUpdate =NO;
//            }]];
//        }
//
//        [self.window.rootViewController presentViewController:la animated:YES completion:nil];
//
//    }
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)remoViewCookies{
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=9.0) {
        //        - (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation 中就成功了 。
        //    然而我们等到了iOS9！！！没错！WKWebView的缓存清除API出来了！代码如下：这是删除所有缓存和cookie的
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    }else{
        //iOS8清除缓存
        NSString * libraryPath =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString * cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
    }
}


@end
