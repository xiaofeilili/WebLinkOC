//
//  WebViewController.m
//  WebLinkOC
//
//  Created by 李晓飞 on 2018/1/16.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)JSContext *context;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView.frame = self.view.bounds;
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"demo.html" ofType:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]];
    [self.webView loadRequest:request];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
#pragma mark - js 调用 oc
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self)wSelf = self;
    _context[@"testargbtn"] = ^(NSString *param){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"内容" message:param preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [wSelf presentViewController:alert animated:YES completion:nil];
        });
    };
    _context[@"testbtn"] = ^{
        NSLog(@"testbtn");
    };
#pragma mark - oc 调用 js
//    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.showName('%@')", self.textStr]];
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.showName('%@')", @"self"]];
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
