//
//  UIViewController+BasicBehavior.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/11.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "JPEmptyView.h"
#import "JPLoadingView.h"
#import "DymRequest+Helper.h"
#import "DymCommonApi.h"
#import "DymStoryboard.h"

@interface UIViewController (BasicBehavior)

/// 记录此VC发出的API请求，以便dealloc时取消
@property (nonatomic, strong) NSMutableArray    *apiQueue;
/// 记录此VC的observer对象，以便dealloc时取消
@property (nonatomic, strong) NSMutableArray    *observerQueue;
/// 空态页面
@property (nonatomic, strong) JPEmptyView       *emptyView;
/// 加载页面
@property (nonatomic, strong) JPLoadingView       *loadingView;

-(void)__doInit;

-(void)__doDealloc;

-(void)__cancelAllRequests;

-(BOOL)__textFieldShouldReturn:(UITextField *)textField;

- (UIStatusBarStyle)__preferredStatusBarStyle;


-(void)dismissPopView;
-(RACCommand *)dismissPopViewCommand;

/// 关掉我
-(void)closeMe;

/// 从storyboard实例化，默认返回nil
+(instancetype)newFromStoryboard;

#pragma mark - orientations
- (BOOL)_shouldAutorotate;
- (UIInterfaceOrientationMask)_supportedInterfaceOrientations;

#pragma mark - api signals
-(RACSignal *)signalWithApiClass:(Class)apiClass params:(NSDictionary *)params;
-(RACSignal *)signalWithApi:(DymRequest *)api;

@end
