//
//  GNWebVC.m
//  GageinNew
//
//  Created by Dong Yiming on 3/12/14.
//  Copyright (c) 2014 Gagein. All rights reserved.
//

#import "UNPWebVC.h"
#import <Masonry/Masonry.h>

#define WEB_PREFIX_HTTP     @"http://"
#define WEB_PREFIX_HTTPS     @"https://"

#define ZOOM_RATIO          (.6f)


@interface UNPWebVC () <UIWebViewDelegate> {
    UIWebView       *_webview;
}

@end



@implementation UNPWebVC

-(instancetype)initWithUrl:(NSString *)aURL naviTitle:(NSString *)aNaviTitle {
    self = [super init];
    if (self) {
        _naviTitle = aNaviTitle;
        _urlStr = aURL;
        _showUrlBar = YES;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _showUrlBar = YES;
    }
    return self;
}

-(void)dealloc
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _webview.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = _naviTitle.length ? _naviTitle : @"网页";
    
    [self initViews];
}

-(void)initViews {
    
    _webview = [UIWebView new];
    _webview.delegate = self;
    _webview.scalesPageToFit = YES;
    [self.view addSubview:_webview];
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self startRequest];
}


#pragma mark - start request
-(void)startRequest {
    if (_urlStr
        && [_urlStr rangeOfString:WEB_PREFIX_HTTP].location == NSNotFound
        && [_urlStr rangeOfString:WEB_PREFIX_HTTPS].location == NSNotFound)
    {
        _urlStr = [NSString stringWithFormat:@"%@%@", WEB_PREFIX_HTTP, _urlStr];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    [_webview loadRequest:request];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"webview loading: {%@}", _urlStr);
}

#pragma mark - web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
