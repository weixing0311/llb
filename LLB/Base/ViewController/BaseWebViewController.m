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
#import "LoignViewController.h"
@interface BaseWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIGestureRecognizerDelegate,UIScrollViewDelegate>
@end

@implementation BaseWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.hidden = YES;;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
    [self.webView stopLoading];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBack)];
    self.navigationItem.leftBarButtonItem = backItem;
    if (self.rightBtnUrl.length>0) {
        UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithTitle:self.rightBtnTitle style:UIBarButtonItemStylePlain target:self action:@selector(enterRightPage)];
        self.navigationItem.rightBarButtonItem = rightitem;
        
    }
    
    
    
    //禁止右划返回
    
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//
//        self.navigationController.interactivePopGestureRecognizer.delegate=self;
//    }
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
    [userContentController addScriptMessageHandler:self name:@"toLoign"];

    configuration.userContentController = userContentController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
//    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    

    
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 70, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-70) configuration:configuration];
    
    NSString  * urlss =@"";
     if ([_urlStr containsString:@"https://"]||[_urlStr containsString:@"http://"])
    {
        urlss =self.urlStr;
    }
    else
    {
        urlss = [kMyBaseUrl stringByAppendingString:self.urlStr];
    }
    
    

    NSURL * url  =[NSURL URLWithString:urlss];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;

    DLog(@"webUrl = %@",url);
    [self.view addSubview:self.webView];

    [self buildProgressView];
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];

        [self.webView loadRequest:request] ;

    // Do any additional setup after loading the view from its nib.
    
}

#pragma mark ---progressview
-(void)buildProgressView
{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, JFA_SCREEN_WIDTH, 2)];
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

//在发送请求之前，决定是否跳转  如果不实现这个代理方法,默认会屏蔽掉打电话等url
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;

    NSString *url = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSString* reUrl=[[webView URL] absoluteString];
    if ([url containsString:kMyBaseUrl]) {
        reUrl=url;
    }
    
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

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
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
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
    //发送头信息
    if ([message.name isEqualToString:@"getHeader"]) {
        [self getHeader];
        //退出页面
    } else if ([message.name isEqualToString:@"exit"]) {
        [self exit];
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
    else if ([message.name isEqualToString:@"setPayInfo"]){
        [self setPayInfoWithMessage:message.body];
    }
    //发送付款信息po
    else if ([message.name isEqualToString:@"getPayInfo"])
    {
        [self sendPayInfo];
    }
    //跳转页面
    else if ([message.name isEqualToString:@"toForward"])
    {
        [self loadUrlWithDict:message.body];
    }else if([message.name isEqualToString:@"toLoign"])
    {
        LoignViewController * lo = [[LoignViewController alloc]init];
        [self presentViewController:lo animated:YES completion:^{
            
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
//    [dic safeSetObject:[UserModel shareInstance].userType forKey:@"userType"];
    
    
    NSString * jsonValue = [self DataTOjsonString:dic];
    NSString *JSResult = [NSString stringWithFormat:@"getUser('%@')",jsonValue];
    
    //    DLog(@"JSResult ===%@",JSResult);
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable user, NSError * _Nullable error) {
        //        NSLog(@"%@----%@",user, error);
    }];
    
    
    //    return dic;
}

-(void)didClickBack
{
    if ([self.title isEqualToString:@"收银台"]) {
        UIAlertController * al = [ UIAlertController alertControllerWithTitle:@"确认要离开收银台？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [al addAction:[UIAlertAction actionWithTitle:@"继续支付" style:UIAlertActionStyleCancel handler:nil]];
        [al addAction: [UIAlertAction actionWithTitle:@"确认离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            [self backWithPayType];
        }]];
        
        [self presentViewController:al animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**
 * 退出web页面
 */
-(void)exit
{
    [self.navigationController popViewControllerAnimated:YES];
}



/**
 *弹窗 alert
 */
-(void) alert:(NSString * )message{
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
    LoignViewController *lo = [[LoignViewController alloc]init];
    self.view.window.rootViewController = lo;
}
/**
 * 充值
 */
-(void)setPayInfoWithMessage:(NSDictionary *)message
{
    if (![message isKindOfClass:[NSDictionary class]]) {
        [[UserModel shareInstance]showInfoWithStatus:@"后台参数错误"];
        return;
    }
    
    
    BaseWebViewController * web =[[BaseWebViewController alloc]init];
    web.payType =4;
    web.urlStr=@"app/checkstand.html";
    web.opt =0;
    web.title = @"收银台";
    web.orderNo = [message safeObjectForKey:@"orderNo"];
    web.payableAmount =[message safeObjectForKey:@"payableAmount"];
    [self.navigationController pushViewController:web animated:YES];
    
    
    //    NSString  * urlss = [kMyBaseUrl stringByAppendingString:@"app/checkstand.html"];
    //    NSURL * url  =[NSURL URLWithString:urlss];
    //    DLog(@"webUrl = %@",url);
    //    [self.webView loadRequest:[NSURLRequest requestWithURL:url]] ;
    
    
    
    
}
/**
 *支付上传数据
 */
-(void)sendPayInfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:[UserModel shareInstance].userId forKey:@"userid"];
    [dic safeSetObject:[UserModel shareInstance].token forKey:@"token"];
//    [dic safeSetObject:[UserModel shareInstance].userType forKey:@"userType"];
    [dic safeSetObject:self.orderNo forKey:@"orderNo"];
    [dic safeSetObject:[NSString stringWithFormat:@"%.2f",[self.payableAmount floatValue]] forKey:@"payableAmount"];
    [dic safeSetObject:@(self.payType) forKey:@"orderType"];
    [dic safeSetObject:@(self.opt) forKey:@"opt"];
    if ([self.integral isEqualToString:@"1"]||[self.integral isEqualToString:@"2"]||[self.integral isEqualToString:@"3"]) {
        [dic safeSetObject:self.integral forKey:@"integral"];
    }
    else{
        [dic safeSetObject:@"0" forKey:@"integral"];
    }
    
    NSString * jsonValue = [self DataTOjsonString:dic];
    NSString * JSResult = [NSString stringWithFormat:@"getOrderInfo('%@')",jsonValue];
    
    DLog(@"JSResult ===%@",JSResult);
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable user, NSError * _Nullable error) {
        NSLog(@"%@----%@",user, error);
    }];
    
}

-(void)getSource
{
    NSString *JSResult = [NSString stringWithFormat:@"getUserSource('app')"];
    
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable user, NSError * _Nullable error) {
        NSLog(@"%@----%@",user, error);
    }];
    
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

/**
 *获取url 中的参数 以字典方式返回
 */
- (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
//    urlStr = @"http://test.fitgeneral.com/mall/notfy.jsp?orderType=3&total_amount=0.01&timestamp=2017-08-14+14:31:26&sign=PvPo75w/XeteSKJ1o+E1EqgPYPlDdUhCONCiARQR92FUJjT2i7gfsmCUCqcYMaeaZqZJQhEHEPm0nAGliUkULkYYKpRCN1A0oZFhzMuLaSXAjc6BcLH6Cy5JwIFVcOMjs2xVMZ5Pm+fVj+GlHqO7w8jrHTF/sxZu3vBB68zj9HbV0Om+t23k39tqK9t6JI7heLSObf1YQ/+MwtBnly+3hx90sKVLw2IaFpKAfEfvVxhvXACur3gF35MysByu8+mDQUdbPZTpH/mvmt2eMYeO1gARh/djxS2ZdJ0brl9HkNQkAsG1NT8e9rtTSklF3wYt9KY8TfLjQY6IadR8iWNolg==&trade_no=2017081421001004940270810861&sign_type=RSA2&auth_app_id=2017050307089464&charset=UTF-8&seller_id=2088621870283133&method=alipay.trade.wap.pay.return&app_id=2017050307089464&out_trade_no=131708141426510531472&version=1.0";
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

//清除WK缓存，否则H5界面跟新，这边不会更新
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


