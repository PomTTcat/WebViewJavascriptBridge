//
//  ExampleWKWebViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "ExampleWKWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "JJWebview.h"

@interface ExampleWKWebViewController ()<UIScrollViewDelegate>

@property WebViewJavascriptBridge* bridge;
@property WKWebView* webView;
@property (assign, nonatomic)   int    c;
@end

@implementation ExampleWKWebViewController

- (void)viewWillAppear:(BOOL)animated {
    if (_bridge) { return; }
    
    //这里我直接把我需要注入的js用文件的方式引入
    NSString *JSfilePath = [[NSBundle mainBundle]pathForResource:@"iosInjectedQuery" ofType:@"js"];
    NSString *JShtml = [NSString stringWithContentsOfFile:JSfilePath encoding:NSUTF8StringEncoding error:nil];
    //此方法是在什么时间点做js注入事件
    WKUserScript *script = [[WKUserScript alloc] initWithSource:JShtml injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];

    // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addUserScript:script];

    CGRect nr = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49 );
    JJWebview* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:nr configuration:config];
//    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    
    webView.scrollView.delegate = self;
    
    [self.view addSubview:webView];
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [self.bridge registerHandler:@"openurl"
                         handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"this is -- openurl openurl",__func__);
    }];
    
    self.c = 0;

    [self.webView reload];
    
    [self renderButtons:webView];
    [self loadExamplePage:webView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
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
}

- (void)loadExamplePage:(WKWebView*)webView {
//    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
//    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
//    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    NSString *urlS = @"x";
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlS]];
    [req addValue:@"iphone" forHTTPHeaderField:@"os"];
    [req addValue:@"2.0.0" forHTTPHeaderField:@"versionname"];
    [webView loadRequest:req];
}
@end
