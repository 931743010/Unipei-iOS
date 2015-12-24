//
//  JPSidePopVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPSidePopVC.h"
#import <Masonry/Masonry.h>
#import "UIViewController+PSContainment.h"
#import "UIViewController+BasicBehavior.h"
#import "JPDesignSpec.h"
#import "JPUtils.h"




@interface JPSidePopVC () {
    UIView                      *_bgTouchView;
    UIView                      *_shadowView;
    
    MASConstraint               *_constraintContentLeading;
    UITapGestureRecognizer      *_tapToDissmiss;
    
    UIView                      *_topCoverBar;
    UIView                      *_topCoverBarDimView;
}

@end

@implementation JPSidePopVC

-(void)setAllowTouchOutsideToDissmiss:(BOOL)allowTouchOutsideToDissmiss {
    
    _allowTouchOutsideToDissmiss = allowTouchOutsideToDissmiss;
    
    if (allowTouchOutsideToDissmiss) {
        [_bgTouchView addGestureRecognizer:_tapToDissmiss];
    } else {
        [_bgTouchView removeGestureRecognizer:_tapToDissmiss];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sideSpace = 48;
    _topMargin = 0;
    
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _bgTouchView = [UIView new];
    _bgTouchView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _bgTouchView.alpha = 0;
    [self.view addSubview:_bgTouchView];
    [_bgTouchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _tapToDissmiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    
    
    _shadowView = [UIView new];
    _shadowView.backgroundColor = [UIColor whiteColor];
    _shadowView.layer.shadowOffset = CGSizeMake(-6, 0);
    _shadowView.layer.shadowRadius = 10;
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowOpacity = 0.25;
    [self.view addSubview:_shadowView];
    
    _topCoverBar = [UIView new];
    _topCoverBar.backgroundColor = [JPDesignSpec colorMajor];
    [self.view addSubview:_topCoverBar];
    [_topCoverBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@20);
    }];
    
    _topCoverBarDimView = [UIView new];
    _topCoverBarDimView.alpha = 0;
    _topCoverBarDimView.backgroundColor = _bgTouchView.backgroundColor;
    [_topCoverBar addSubview:_topCoverBarDimView];
    [_topCoverBarDimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_topCoverBar);
    }];
    
    self.allowTouchOutsideToDissmiss = YES;
}


-(void)showVC:(UIViewController *)vcToShow {

    _showingVC = vcToShow;
    
    /// 安装vc
    @weakify(self)
    [self installChildVC:_showingVC toContainerView:self.view layoutBlock:^(UIView *childView, UIView *containerView) {
       [childView mas_makeConstraints:^(MASConstraintMaker *make) {
           @strongify(self)
           _constraintContentLeading = make.leading.equalTo(self.view.mas_leading).offset(CGRectGetMaxX(self.view.frame));
           make.top.equalTo(self.view.mas_top).offset(_topMargin);
           make.bottom.equalTo(self.view.mas_bottom);
           make.width.equalTo(@(CGRectGetMaxX(self.view.frame) - _sideSpace));
       }];
    }];
    
    /// 对齐阴影
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_showingVC.view);
    }];
    
    [self.view bringSubviewToFront:_topCoverBar];
    
    /// 设置导航条样式
    UINavigationController *nc = (UINavigationController *)
    ([_showingVC isKindOfClass:[UINavigationController class]] ? _showingVC : _showingVC.navigationController);
    
    nc.interactivePopGestureRecognizer.enabled = NO;
    nc.navigationBar.barTintColor = [JPDesignSpec colorWhiteDark];
    nc.navigationBar.translucent = NO;
    nc.navigationBar.tintColor = [JPDesignSpec colorGray];
    nc.navigationBar.barStyle = UIBarStyleBlackOpaque;
    nc.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blackColor]};
    
    /// 开启god mode显示
    [JPUtils openGodModeWithVC:self];
    
    /// 动画
    [UIView animateWithDuration:0.1 animations:^{
        _bgTouchView.alpha = 1;
        _topCoverBarDimView.alpha = _bgTouchView.alpha;
    } completion:^(BOOL finished) {
        
        _constraintContentLeading.offset = _sideSpace;
        [UIView animateWithDuration:0.15 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}


-(void)dismiss {
    
    _constraintContentLeading.offset = [UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.35 animations:^{
            _bgTouchView.alpha = 0;
            _topCoverBarDimView.alpha = _bgTouchView.alpha;
        } completion:^(BOOL finished) {
            [_showingVC uninstallFromParent];
            _showingVC = nil;
            
            [JPUtils closeGodMode];
            
        }];
    }];
    
}

@end
