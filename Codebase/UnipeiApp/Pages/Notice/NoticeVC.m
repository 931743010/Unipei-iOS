//
//  NoticeVC.m
//  DymIOSApp
//
//  Created by xujun on 15/12/23.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "NoticeVC.h"
#import <Masonry/Masonry.h>

@interface NoticeVC ()<UIWebViewDelegate>
{
    UIWebView               *_webView;
    UIActivityIndicatorView *_indicatorView;
}
@end

@implementation NoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _dataDic[@"title"];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView setBackgroundColor:[UIColor whiteColor]];
    //    自动对页面进行缩放以适应屏幕
//    [_webView setScalesPageToFit:YES];
    //    设置代理
    [_webView setDelegate:self];
    
    [self.view addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:_dataDic[@"url"]];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [_indicatorView startAnimating];
    [_webView addSubview:_indicatorView];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_webView.mas_centerX);
        make.top.equalTo(_webView);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
}
#pragma mark - webviewdelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = request.URL;
        [[UIApplication sharedApplication] openURL:url];
        
        return NO;
    }
    
    return YES;
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{

    [_indicatorView startAnimating];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{

    [_indicatorView stopAnimating];
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [_indicatorView stopAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
