//
//  UIViewController+BasicBehavior.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/11.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UIViewController+BasicBehavior.h"
#import <objc/runtime.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "JPDesignSpec.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "JPSidePopVC.h"
#import <YTKNetwork/YTKBatchRequest.h>


static const DDLogLevel ddLogLevel = DDLogLevelDebug;

static const void *UIViewControllerAPIsKey = &UIViewControllerAPIsKey;
static const void *UIViewControllerObserversKey = &UIViewControllerObserversKey;
static const void *UIViewControllerEmptyViewKey = &UIViewControllerEmptyViewKey;
static const void *UIViewControllerLoadingViewKey = &UIViewControllerLoadingViewKey;

@implementation UIViewController (BasicBehavior)

#pragma mark - associated objects
-(void)setObserverQueue:(NSMutableArray *)observerQueue {
    objc_setAssociatedObject(self, UIViewControllerObserversKey, observerQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)observerQueue {
    return objc_getAssociatedObject(self, UIViewControllerObserversKey);
}

- (void)setApiQueue:(NSMutableArray *)apiQueue {
    objc_setAssociatedObject(self, UIViewControllerAPIsKey, apiQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)apiQueue {
    return objc_getAssociatedObject(self, UIViewControllerAPIsKey);
}

-(void)setEmptyView:(JPEmptyView *)emptyView {
    objc_setAssociatedObject(self, UIViewControllerEmptyViewKey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(JPEmptyView *)emptyView {
    return objc_getAssociatedObject(self, UIViewControllerEmptyViewKey);
}

-(void)setLoadingView:(JPLoadingView *)loadingView {
    objc_setAssociatedObject(self, UIViewControllerLoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(JPLoadingView *)loadingView {
    return objc_getAssociatedObject(self, UIViewControllerLoadingViewKey);
}

#pragma mark -
-(void)__doInit {
    self.apiQueue = [NSMutableArray array];
    self.observerQueue = [NSMutableArray array];
    
    JPEmptyView *emptyView = [JPEmptyView new];
    emptyView.backgroundColor = [JPDesignSpec colorSilver];
    self.emptyView = emptyView;
    
    JPLoadingView *loadingView = [JPLoadingView new];
    loadingView.backgroundColor = [JPDesignSpec colorSilver];
    self.loadingView = loadingView;
    
    self.view.backgroundColor = [JPDesignSpec colorSilver];
    
    DDLogDebug(@"Creating [%@] object...", NSStringFromClass([self class]));
}

-(void)__doDealloc {
    
    DDLogDebug(@"Deallocating [%@] object...", NSStringFromClass([self class]));
    [self __cancelAllRequests];
    [self __removeNotificationObservers];
}

-(void)__cancelAllRequests {
    for (DymRequest *api in self.apiQueue) {
        if ([api isKindOfClass:[DymRequest class]]) {
            [api stop];
        } else if ([api isKindOfClass:[YTKBatchRequest class]]) {
            [(YTKBatchRequest *)api stop];
        }
    }
    [self.apiQueue removeAllObjects];
}

-(void)__removeNotificationObservers {
    for (id observer in self.observerQueue) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    
    [self.observerQueue removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)__textFieldShouldReturn:(UITextField *)textField {
    
    if ([[IQKeyboardManager sharedManager] canGoNext]) {
        [[IQKeyboardManager sharedManager] goNext];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (UIStatusBarStyle)__preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - dismiss
-(RACCommand *)dismissPopViewCommand {
    @weakify(self)
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self dismissPopView];
        
        return [RACSignal empty];
    }];
}

-(void)dismissPopView {
    UIViewController *rootVC = self.view.window.rootViewController;
    if ([rootVC isKindOfClass:[JPSidePopVC class]]) {
        [((JPSidePopVC *)self.view.window.rootViewController) dismiss];
    }
}

-(void)closeMe {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

+(instancetype)newFromStoryboard {
    return nil;
}

#pragma mark - orientations
- (BOOL)_shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)_supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - signals
-(RACSignal *)signalWithApiClass:(Class)apiClass params:(NSDictionary *)params {
    return [DymRequest commonApiSignalWithClass:apiClass queue:self.apiQueue params:params];
}

-(RACSignal *)signalWithApi:(DymRequest *)api {
    return [DymRequest commonApiSignal:api queue:self.apiQueue];
}

@end
