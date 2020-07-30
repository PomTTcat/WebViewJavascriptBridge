//
//  ExampleWKWebViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "ExampleWKWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ExampleWKWebViewController ()<WKUIDelegate>

@property WebViewJavascriptBridge* bridge;

@end

@implementation ExampleWKWebViewController

- (void)viewWillAppear:(BOOL)animated {
    if (_bridge) { return; }
    
    
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *filePath = [bundle pathForResource:@"injectJSCode" ofType:@"js"];
//    NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    // 注入js
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];    // openurl成功，注入时间是start。
//    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
//    [userContentController addUserScript:userScript];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    
    CGRect nR = CGRectMake(0, 0, self.view.bounds.size.width,  (self.view.bounds.size.height-49));
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:nR configuration:config];
//    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:nR];
//    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view addSubview:webView];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    [_bridge disableJavscriptAlertBoxSafetyTimeout];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    [_bridge registerHandler:@"openurl" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"openurl called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    [_bridge registerHandler:@"getShareInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"openurl called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    [_bridge registerHandler:@"getBaseInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"getBaseInfo called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
//    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
////    [_bridge callHandler:@"openurl" data:@{ @"foo":@"before ready" }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [_bridge callHandler:@"openurl" data:@{ @"foo":@"before ready" }];
//    });
    
    [self renderButtons:webView];
    [self loadExamplePage:webView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)renderButtons:(WKWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadExamplePage:(WKWebView*)webView {
//    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
//    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
//    [webView loadHTMLString:appHtml baseURL:baseURL];

//    http://h5.hrloo.com/h5/target/comment.html?id=5010578&check=0
    NSURL *nsurl = [NSURL URLWithString:@"http://h5.hrloo.com/h5/target/comment.html?id=5010578&check=0"];
//    NSURL *nsurl = [NSURL URLWithString:@"http://10.1.16.140:5501/H5nativeCommunicate.html"];
//    NSURL *nsurl = [NSURL URLWithString:@"http://h5.hrloo.com/h5/target/punch.html?id=73836"];
//    NSURL *nsurl = [NSURL URLWithString:@"http://www.hrloo.com/hr/special/vip/app_memeber"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:nsurl];
    [request setValue:@"iphone" forHTTPHeaderField:@"OS"];
    [request setValue:@"2.0.0" forHTTPHeaderField:@"versionname"];
    
    [webView loadRequest:request];
}
@end


// 注册比较多
