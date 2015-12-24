//
//  JPIntrinsicWebView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/4.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "JPIntrinsicWebView.h"
#import <Masonry/Masonry.h>


static CGFloat  minContentHeight = 100;


@interface JPIntrinsicWebView () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView   *webview;

@property (nonatomic, assign) CGFloat     contentHeight;

@end

@implementation JPIntrinsicWebView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit {
    _webview = [UIWebView new];
    _webview.scrollView.scrollEnabled = NO;
    _webview.delegate = self;
    [self addSubview:_webview];
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(CGFloat)contentHeight {
    if (_contentHeight < minContentHeight) {
        _contentHeight = minContentHeight;
    }
    
    return _contentHeight;
}

-(CGSize)intrinsicContentSize {
    CGRect frame = self.frame;
    
    return CGSizeMake(frame.size.width, self.contentHeight);
}

#pragma mark - load
-(void)loadPlainText:(NSString *)plainText {
    if (plainText) {
        NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        [_webview loadData:data MIMEType:@"text/plain" textEncodingName:@"utf-8" baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        
        _webview.dataDetectorTypes = UIDataDetectorTypeLink;
    }
    
}

-(void)loadURL:(NSString *)url {
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    CGFloat newHeight = aWebView.scrollView.contentSize.height;
    if (newHeight != _contentHeight) {
        _contentHeight = aWebView.scrollView.contentSize.height;
        
        [self invalidateIntrinsicContentSize];
        
        if (_contentLoadedBlock) {
            _contentLoadedBlock();
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = request.URL;
        [[UIApplication sharedApplication] openURL:url];
        
        return NO;
    }
    
    return YES;
}

@end
