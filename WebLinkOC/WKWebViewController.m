//
//  WKWebViewController.m
//  WebLinkOC
//
//  Created by 李晓飞 on 2018/1/18.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>


@interface WKWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong)WKWebView *webView;

@end

@implementation WKWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // js调用oc linkTest、testbtn 都是和后台约定好的方法名；要在webView添加之后调用
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"linkTest"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"testbtn"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"linkTest"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"testbtn"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKUserContentController *wkUserCtrl = [WKUserContentController new];
        
        WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
        wkConfig.userContentController = wkUserCtrl;
        wkConfig.preferences.javaScriptEnabled = YES;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [self loadLocalDocument];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}
/**
 * 加载本地文件
 */
- (void)loadLocalDocument {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"demo.html" ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:html baseURL:nil];
}
/**
 * 加载线上文件
 */
- (void)loadOnlineFile {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"] cachePolicy:1 timeoutInterval:2];
    [_webView loadRequest:request];
}
// html加载完成再插入js
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"aaaaa");
    // 标题
    if (webView.title) {
        self.title = webView.title;
    }
    
    // OC 调用 js
    if (self.textStr.length == 0) {
        self.textStr = @"null";
    }
    NSString *js = [NSString stringWithFormat:@"showName('%@')", self.textStr];
    [webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result %@", result);
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"1245%@", error);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"runJavaScriptAlertPanel:%@  %@", message, frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
//
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
//    NSLog(@"runJavaScriptConfirmPanel:%@", message);
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(NO);
//    }])];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(YES);
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
//    NSLog(@"runJavaScriptTextInputPanel");
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.text = defaultText;
//    }];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(alertController.textFields[0].text?:@"");
//    }])];
//
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}

#pragma mark - WKScriptMessageHandler
// js 调用 OC
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@", message);
    if ([message.name isEqualToString:@"linkTest"]) {
        
    }else if ([message.name isEqualToString:@"testbtn"]) {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
