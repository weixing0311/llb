//
//  BaseWebViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

//
//  BaseWebViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BaseWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LoignViewController.h"
#import "WXAlipayController.h"
#import "PaySuccessViewController.h"
#import "PayingViewController.h"
#import "OrderViewController.h"
#import "FirstTabbarViewController.h"
#import "GoodsDetailViewController.h"
@interface BaseWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIGestureRecognizerDelegate,UIScrollViewDelegate>
@end

@implementation BaseWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    if ([self.urlStr containsString:@"app/shopCard.html"]||[self.urlStr containsString:@"app/userInfo.html"]) {
        [self showTabbar];
    }else{
        [self hiddenTabbar];
    }
    
//    [self.webView reload];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
    [self.webView stopLoading];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    self.view.backgroundColor = [UIColor greenColor];

    if (self.rightBtnUrl.length>0) {
        UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithTitle:self.rightBtnTitle style:UIBarButtonItemStylePlain target:self action:@selector(enterRightPage)];
        self.navigationItem.rightBarButtonItem = rightitem;
        
    }
    
    
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

    
    
    
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:wkUScript];

    [userContentController addScriptMessageHandler:self name:@"getHeader"];
    [userContentController addScriptMessageHandler:self name:@"exit"];
    [userContentController addScriptMessageHandler:self name:@"hideLoad"];
    [userContentController addScriptMessageHandler:self name:@"exitToLogin"];
    [userContentController addScriptMessageHandler:self name:@"alert"];
    [userContentController addScriptMessageHandler:self name:@"loading"];
    [userContentController addScriptMessageHandler:self name:@"getSource"];
    [userContentController addScriptMessageHandler:self name:@"getPayInfo"];
    [userContentController addScriptMessageHandler:self name:@"setPayInfo"];
    [userContentController addScriptMessageHandler:self name:@"toReorder"];
    [userContentController addScriptMessageHandler:self name:@"toForward"];
    [userContentController addScriptMessageHandler:self name:@"toLogin"];
    [userContentController addScriptMessageHandler:self name:@"didClickPay"];
    [userContentController addScriptMessageHandler:self name:@"payCallback"];
    [userContentController addScriptMessageHandler:self name:@"share"];
    [userContentController addScriptMessageHandler:self name:@"getCheckHeader"];
    [userContentController addScriptMessageHandler:self name:@"pay"];
    [userContentController addScriptMessageHandler:self name:@"exitToRoot"];


    configuration.userContentController = userContentController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    
    

    
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT) configuration:configuration];
    
    NSString  * urlss =@"";
     if ([_urlStr containsString:@"https://"]||[_urlStr containsString:@"http://"])
    {
        urlss =self.urlStr;
    }
    else
    {
        urlss = [kMyBaseUrl stringByAppendingString:self.urlStr];
    }
    
    if ([urlss containsString:@"https://wx.tenpay.com"] ) {
        if ([urlss containsString:@"redirect_url"]) {
            
            NSDictionary *dic =[self getURLParameters:urlss];
            DLog(@"%@",dic);
//            self.wxPayCallBackUrl = [dic safeObjectForKey:@"redirect_url"];
            NSArray *array = [urlss componentsSeparatedByString:@"?"]; //从字符A中分隔成2个元素的数组
            
            urlss =[NSString stringWithFormat:@"%@?package=%@&prepay_id=%@",array[0],[dic safeObjectForKey:@"package"],[dic safeObjectForKey:@"prepay_id"]];
        }
    }

    
    
    NSURL * url  =[NSURL URLWithString:urlss];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;

    DLog(@"webUrl = %@",url);
    [self.view addSubview:self.webView];

    [self buildProgressView];
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    if ([urlss containsString:@"https://wx.tenpay.com"]) {
        NSDictionary *headers = [request allHTTPHeaderFields];
        BOOL hasReferer = [headers objectForKey:@"Referer"]!=nil;
        if (hasReferer) {
            // .. is this my referer?
        } else {
            // relaunch with a modified request
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSURL *url = [request URL];
                    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                    [request setHTTPMethod:@"GET"];
                    NSString * referer = [NSString stringWithFormat:@"%@://",weChatPayRefere];
                    
                    [request setValue:referer forHTTPHeaderField: @"Referer"];
                    [self.webView loadRequest:request] ;
                });
            });
        }
    }else{
        [self.webView loadRequest:request] ;
    }


//        [self.webView loadRequest:request] ;

    // Do any additional setup after loading the view from its nib.
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNewNet:) name:@"LoginSuccessLoadNewNet" object:nil];
    
    
}

#pragma mark ---progressview
-(void)buildProgressView
{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    [self.view addSubview:self.progressView];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSString* reUrl=[[webView URL] absoluteString];
    if ([url containsString:kMyBaseUrl]) {
        reUrl=url;
    }
    DLog(@"url---%@",url);
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    if ([url containsString:@"weixindetermine.jsp?"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    DLog(@"navi.url --%@",url);
    if ([url containsString:@"alipay://"]) {
        NSString* dataStr=[url substringFromIndex:23];
        NSLog(@"%@",dataStr);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ NSString stringWithFormat:@"alipay://alipayclient/?%@",[self encodeString:dataStr]]]];// 对参数进行urlencode，拼接上scheme。
        
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }

    
    if ([url containsString:@"weixin://wap/pay?"]) {
        
        if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        }

        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    if ([url containsString:@"app/shopCard.html"]||[url containsString:@"app/userInfo.html"]) {
        [self showTabbar];
    }else{
        [self hiddenTabbar];
        
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

//在发送请求之前，决定是否跳转  如果不实现这个代理方法,默认会屏蔽掉打电话等url

-(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)unencodedString,
                                                              
                                                              NULL,
                                                              
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    
    
    DLog(@"%ld",(long)((NSHTTPURLResponse *)navigationResponse.response).statusCode);
    if (((NSHTTPURLResponse *)navigationResponse.response).statusCode == 200) {
        decisionHandler (WKNavigationResponsePolicyAllow);
        
    }else {
        decisionHandler(WKNavigationResponsePolicyCancel);
        [[UserModel shareInstance]showInfoWithStatus:@"404"];
    }
}
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
      completionHandler();
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //message.boby就是JS里传过来的参数
    //    NSLog(@"body:%@--%@",message.body,message);
    //    DLog(@"name--%@",message.name);
    [self didShowInfoWithMessage:message];
}


-(void)loadUrlWithDict:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        [[UserModel shareInstance]showInfoWithStatus:@"后台参数错误"];
        return;
    }
    
    
    NSString * urlstring = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"url"]];
    if ([urlstring containsString:kMyBaseUrl]) {
        urlstring = [urlstring stringByReplacingOccurrencesOfString:kMyBaseUrl withString:@""];

    }
    
    BaseWebViewController * web = [[BaseWebViewController alloc]init];
    web.title  = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"title"]];
    web.urlStr = urlstring;
    NSString *rightUrl = [dict safeObjectForKey:@"preUrl"];
    NSString * rightTitle =[dict safeObjectForKey:@"preTitle"];
    if (rightUrl.length>0) {
        web.rightBtnUrl =rightUrl;
        web.rightBtnTitle =rightTitle;
    }
    [self.navigationController pushViewController:web animated:YES];
}
-(void)enterRightPage
{
    BaseWebViewController * web = [[BaseWebViewController alloc]init];
    web.title  = self.rightBtnTitle;
    web.urlStr = self.rightBtnUrl;
    [self.navigationController pushViewController:web animated:YES];
}


#pragma mark ----已购服务跳转
// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
    
//    [self showTabbarWithUrl:webView.URL.absoluteString];
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    DLog(@"当内容开始返回时调用");
}

// 页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.progressView.hidden = YES;

    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
    
    
    [self remoViewCookies];

}
// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    [[UserModel shareInstance]showInfoWithStatus:@"加载失败"];
    [self.navigationController popViewControllerAnimated:YES];
}

///web调用方法
-(void)didShowInfoWithMessage:(WKScriptMessage*)message
{
    
    DLog(@"调用了！！方法名:>>(%@)<<",message.name);
    //发送头信息
    if ([message.name isEqualToString:@"getHeader"]) {
        [self getHeader];
        //退出页面
    } else if ([message.name isEqualToString:@"exit"]) {
        [self exit];
    }
    else if([message.name isEqualToString:@"exitToRoot"])
    {
        [self exitToroot:message.body];
    }
    
    //隐藏Loading
    else if ([message.name isEqualToString:@"hideLoad"]) {
        
        [self hideLoad];
    }
    //退出登录
    else if ([message.name isEqualToString:@"exitToLogin"]) {
        
        [self exitToLogin];
    }
    //显示弹窗
    else if ([message.name isEqualToString:@"alert"]) {
        
        [self alert:message.body];
    }
    //显示loading
    else if ([message.name isEqualToString:@"loading"]) {
        
        [self loading:message.body];
    }
    //发送来源 app web
    else if ([message.name isEqualToString:@"getSource"])
    {
        [self getSource];
    }
    //跳转页面
    else if ([message.name isEqualToString:@"toForward"])
    {
        [self loadUrlWithDict:message.body];
    }else if([message.name isEqualToString:@"toLogin"])
    {
        
        DLog(@"tologinUrl--%@",message.body);
        [UserModel shareInstance].loginOpenUrl = message.body;
        LoignViewController * lo = [[LoignViewController alloc]init];
        [self presentViewController:lo animated:YES completion:^{
            
        }];
    }
    else if ([message.name isEqualToString:@"payCallback"])
    {
        [self payCallBackWithInfo:message.body];
    }
    else if ([message.name isEqualToString:@"didClickPay"])
    {
        [self didPayWithInfo:message.body];
    }
    else if ([message.name isEqualToString:@"share"])
    {
        [self showShareMenuWithDict:message.body];
    }
    else if([message.name isEqualToString:@"getCheckHeader"])
    {
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:[UserModel shareInstance].userId forKey:@"userid"];
        [dic safeSetObject:[UserModel shareInstance].token forKey:@"token"];
        [dic safeSetObject:[UserModel shareInstance].nickName forKey:@"name"];
        
        
        NSString * jsonValue = [self DataTOjsonString:dic];
        NSString *JSResult = [NSString stringWithFormat:@"getCheckUser('%@')",jsonValue];
        
        //    DLog(@"JSResult ===%@",JSResult);
        [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable user, NSError * _Nullable error) {
            NSLog(@"getUser%@----%@",user, error);
        }];

    }
}


/**
 * 请求头
 */

-(void) getHeader{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:[UserModel shareInstance].userId forKey:@"userid"];
    [dic safeSetObject:[UserModel shareInstance].token forKey:@"token"];
    [dic safeSetObject:[UserModel shareInstance].nickName forKey:@"name"];
    
    
    NSString * jsonValue = [self DataTOjsonString:dic];
    NSString *JSResult = [NSString stringWithFormat:@"getUser('%@')",jsonValue];
    
    //    DLog(@"JSResult ===%@",JSResult);
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable user, NSError * _Nullable error) {
            NSLog(@"getUser%@----%@",user, error);
    }];
    
    
    //    return dic;
}

//-(void)didClickBack
//{
//    if ([self.title isEqualToString:@"收银台"]) {
//        UIAlertController * al = [ UIAlertController alertControllerWithTitle:@"确认要离开收银台？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//        [al addAction:[UIAlertAction actionWithTitle:@"继续支付" style:UIAlertActionStyleCancel handler:nil]];
//        [al addAction: [UIAlertAction actionWithTitle:@"确认离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
////            [self backWithPayType];
//        }]];
//
//        [self presentViewController:al animated:YES completion:nil];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}


/**
 * 退出web页面
 */
-(void)exit
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)exitToroot:(id)messagee
{
    [self.webView stopLoading];
    
//    if (self.navigationController.viewControllers.count<2) {
//        [self.webView goBack];
//        return;
//    }
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *controller = app.window.rootViewController;
    
//    [（SuerTabBarViewController是继承于TabBarViewController的相当于mainViewController）】
     FirstTabbarViewController *rvc = (FirstTabbarViewController *)controller;
    
    [rvc setSelectedIndex:[messagee intValue]-1];//假如要跳转到第四个tabBar那里，因为tabBar默认索引是从0开始的
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
   
    
}
-(void)popToRootWithPage:(int)page
{
    
}

/**
 *弹窗 alert
 */
-(void) alert:(NSString * )message{
    DLog(@"弹窗了 内容----%@",message);
    [[UserModel shareInstance] showInfoWithStatus:message];
    
}
/**
 *弹loading
 */
-(void) loading:(NSString * )message{
    [SVProgressHUD showWithStatus:message];
    
}

/**
 *隐藏loading
 */
-(void)hideLoad
{
    [SVProgressHUD dismiss];
}

/**
 *退出登录
 */
-(void)exitToLogin
{
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kMyloignInfo];
    [[UserModel shareInstance]removeAllObject];
    self.navigationController.tabBarController.selectedIndex =0;
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    LoignViewController *lo = [[LoignViewController alloc]init];
//    self.view.window.rootViewController = lo;
}

-(void)getSource
{
    NSString *JSResult = [NSString stringWithFormat:@"getUserSource('app')"];
    
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable user, NSError * _Nullable error) {
        NSLog(@"%@----%@",user, error);
    }];
    
}
-(void)loadNewNet:(NSNotification *)noti
{
    
    NSString * url = [noti.userInfo objectForKey:@"urlStr"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}




-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}






#pragma mark ---清除WK缓存，否则H5界面跟新，这边不会更新
///清除WK缓存，否则H5界面跟新，这边不会更新
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

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}




#pragma mark ---分享
-(void)showShareMenuWithDict:(NSDictionary *)dict
{
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWXwithUrl:dict Session:0];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWXwithUrl:dict Session:1];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:al animated:YES completion:nil];
}

///微信分享
-(void)shareWXwithUrl:(NSDictionary *)dict Session:(int)session
{
    SendMessageToWXReq *req1 = [[SendMessageToWXReq alloc]init];

    // 是否是文档
    req1.bText =  NO;
    
    //    WXSceneSession  = 0,        /**< 聊天界面    */
    //    WXSceneTimeline = 1,        /**< 朋友圈      */
    //    WXSceneFavorite = 2,
    
    
    req1.scene = session;
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = [dict safeObjectForKey:@"title"];//kLinkTitle;//分享标题
    urlMessage.description = [dict safeObjectForKey:@"description"];//kLinkDescription;//分享描述
    
    NSData  * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict safeObjectForKey:@"img"]]];
    
    [urlMessage setThumbImage:[UIImage imageWithData:data]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = [dict safeObjectForKey:@"linkUrl" ];//kLinkURL;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    req1.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:req1];
    
    
}

-(void)didPayWithInfo:(NSDictionary *)infoDict
{
//    platform 支付平台 1 支付宝 2 微信 3 银联
//    url 支付地址
//    payFlag 1 需要支付完成需要跳转 2 不需要
//    orderType 1 代表下单 2 代理 3欢乐豆 ---2跳个人中心
//    orderUrl 配合payFlag使用 在payFlag为1的情况下需要
//    payFlag 与 orderUrl场景说明：在支付完成之后需要跳转到订单页面
    

    NSString * platform = [infoDict safeObjectForKey:@"platform"];
    NSString * url = [infoDict safeObjectForKey:@"url"];
    NSString * payFlag = [infoDict safeObjectForKey:@"payFlag"];
    NSString * orderType = [infoDict safeObjectForKey:@"orderType"];
    self.wxPayCallBackUrl = [infoDict safeObjectForKey:@"redirectUri"];
    self.orderUrl = [infoDict safeObjectForKey:@"orderUrl"];

    
    
    PayingViewController * web = [[PayingViewController alloc]init];
    web.urlStr = url;
    web.wxPayCallBackUrl = self.wxPayCallBackUrl;
    web.orderUrl = self.orderUrl;
    web.orderType =orderType;
    [self.navigationController pushViewController:web animated:YES];

    
    
}
-(void)payCallBackWithInfo:(id )infoDict
{
    
    DLog(@"payCallBack ---%@",infoDict);
    
    if ([self.orderType isEqualToString:@"2"]) {
        [self exitToroot:@"4"];
    }else{
        OrderViewController  * pay =[[OrderViewController alloc]init];
        pay.urlStr =self.orderUrl;
        [self.navigationController pushViewController:pay animated:YES];
    }    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


