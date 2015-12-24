//
//  JPSidePopVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"

@interface JPSidePopVC : DymBaseVC

/// 正在显示的vc
@property (nonatomic, strong, readonly) UIViewController        *showingVC;

/// 是否允许点击页边空白dismiss
@property (nonatomic, assign) BOOL                              allowTouchOutsideToDissmiss;

/// 侧边空白宽度，默认48
@property (nonatomic, assign) CGFloat               sideSpace;

/// 顶部空白，默认20
@property (nonatomic, assign) CGFloat               topMargin;

/// 显示vc
-(void)showVC:(UIViewController *)vcToShow;

/// 隐藏
-(void)dismiss;

@end
