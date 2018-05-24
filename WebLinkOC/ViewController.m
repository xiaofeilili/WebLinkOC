//
//  ViewController.m
//  WebLinkOC
//
//  Created by 李晓飞 on 2018/1/16.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "WKWebViewController.h"
#import "NavViewController.h"

#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()

@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *submitBtn;

@property (nonatomic, strong)UIButton *navBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textField.frame = CGRectMake((kScreenWidth - 100)/2, 200, 100, 40);
    
    self.submitBtn.frame = CGRectMake((kScreenWidth - 100)/2, 300, 100, 40);
    
    self.navBtn.frame = CGRectMake((kScreenWidth - 100)/2, 400, 100, 40);
    
}

- (void)submitButtonClick {
    if ([self.textField.text length]) {
        WebViewController *webVc = [[WebViewController alloc] init];
        webVc.textStr = self.textField.text;
        [self.navigationController pushViewController:webVc animated:YES];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)navButtonClick {
//    WKWebViewController *webVc = [[WKWebViewController alloc] init];
//    [self.navigationController pushViewController:webVc animated:YES];
//    NavViewController *navVC = [[NavViewController alloc] init];
//    [self.navigationController pushViewController:navVC animated:YES];
    WebViewController *webVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.layer.cornerRadius = 4;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.layer.borderWidth = 1.0f;
        [self.view addSubview:_textField];
    }
    return _textField;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.backgroundColor = [UIColor brownColor];
        _submitBtn.layer.cornerRadius = 4;
        [self.view addSubview:_submitBtn];
        [_submitBtn addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UIButton *)navBtn {
    if (!_navBtn) {
        _navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBtn.backgroundColor = [UIColor brownColor];
        _navBtn.layer.cornerRadius = 4;
        [self.view addSubview:_navBtn];
        [_navBtn addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
