//
//  UNPAgreementVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/28.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPAgreementVC.h"
#import "JPSubmitButton.h"
#import "UNPChangeInitPwdVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UNPAgreementVC () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnNext;

@end

@implementation UNPAgreementVC

+(instancetype)newFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Unipei_User" bundle:nil] instantiateViewControllerWithIdentifier:@"UNPAgreementVC"];
}

- (void)viewDidLoad {
    @weakify(self)
    [super viewDidLoad];
    self.navigationItem.title = @"服务协议";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xlc_xy" ofType:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    _webView.delegate = self;
    [_webView loadHTMLString:html baseURL:nil];
    
    _btnNext.style = kJPButtonOrange;
    RAC(_btnNext, enabled) = RACObserve(_btnAgree, selected);
    
    [[_btnAgree rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        button.selected = !button.selected;
    }];
    
    [[_btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        UNPChangeInitPwdVC *vc = [UNPChangeInitPwdVC newFromStoryboard];
        vc.loginInfo = self.loginInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadingView:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self showLoadingView:NO];
}

@end
