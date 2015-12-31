//
//  UNPIntroVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/26.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPIntroVC.h"
#import "JPDesignSpec.h"
#import <Masonry/Masonry.h>

@interface UNPIntroVC () {
    UIScrollView    *_scrollView;
    
    UIView          *_viewIntro1;
    UIView          *_viewIntro2;
    UIView          *_viewIntro3;
    UIView          *_viewIntro4;
    UIView          *_viewIntro5;
    
    NSArray         *_viewIntros;
    NSArray         *_imageIntros;
    NSArray         *_imageBgIntros;
    
    UIButton        *_btnStart;
    UIColor         *_leadingColor;
    UIColor         *_trailingColor;
}
// 62,132,143
// 113,144,25
@end

@implementation UNPIntroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _leadingColor = [UIColor colorWithRed:153/255.0 green:217/255.0 blue:236/255.0 alpha:1];
    _trailingColor = [UIColor colorWithRed:49/255.0 green:63/255.0 blue:112/255.0 alpha:1];
    
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [JPDesignSpec colorMajor];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //
    _viewIntro1 = [UIView new];
    _viewIntro2 = [UIView new];
    _viewIntro3 = [UIView new];
    _viewIntro4 = [UIView new];
    _viewIntro5 = [UIView new];
    
    _viewIntros = @[_viewIntro1, _viewIntro2, _viewIntro3, _viewIntro4, _viewIntro5];
    _imageIntros = @[@"intro_1", @"intro_2" ,@"intro_3", @"intro_4", @"intro_5"];
    _imageBgIntros = @[@"intro_1_bg", @"intro_2_bg" ,@"intro_3_bg", @"intro_4_bg", @"intro_5_bg"];
    
    
    //
    [_viewIntros enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self initIntroViewForIndex:idx];
    }];
    
    _btnStart = [UIButton new];
    [_btnStart setImage:[UIImage imageNamed:@"intro_login_btn"] forState:UIControlStateNormal];
    [_viewIntro5 addSubview:_btnStart];
    CGFloat horizGap = 30 * [UIScreen mainScreen].scale;
    [_btnStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_viewIntro5.mas_leading).offset(horizGap);
        make.trailing.equalTo(_viewIntro5.mas_trailing).offset(-horizGap);
        make.centerY.equalTo(_viewIntro5.mas_centerY).offset(90 * [UIScreen mainScreen].scale);
        make.width.equalTo(_btnStart.mas_height).multipliedBy(0.18);
    }];
    
    @weakify(self)
    [[_btnStart rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        if (self.dismissedBlock) {
            self.dismissedBlock();
        }
    }];

    //
    __block UIView *lastView = nil;
    [_viewIntros enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_scrollView addSubview:obj];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView == nil) {
                make.leading.equalTo(_scrollView.mas_leading);
                make.top.equalTo(_scrollView.mas_top);
                make.bottom.equalTo(_scrollView.mas_bottom);
                make.width.equalTo(_scrollView.mas_width);
                make.height.equalTo(_scrollView.mas_height);
            } else {
                make.leading.equalTo(lastView.mas_trailing);
                make.top.equalTo(lastView.mas_top);
                make.width.equalTo(lastView.mas_width);
                make.height.equalTo(lastView.mas_height);
            }
            
            if (idx == _viewIntros.count - 1) {
                make.trailing.equalTo(_scrollView.mas_trailing);
            }
            
            lastView = obj;
        }];
    }];
}

-(void)initIntroViewForIndex:(NSInteger)index {
    
    UIView *viewIntro = _viewIntros[index];
    
    UIImageView *ivIntroBg = [UIImageView new];
    ivIntroBg.image = [UIImage imageNamed:_imageBgIntros[index]];
    [viewIntro addSubview:ivIntroBg];
    [ivIntroBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewIntro);
    }];
    
    UIImageView *ivIntro = [UIImageView new];
    ivIntro.contentMode = UIViewContentModeScaleAspectFit;
    ivIntro.image = [UIImage imageNamed:_imageIntros[index]];
    [viewIntro addSubview:ivIntro];
    [ivIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewIntro);
        make.width.lessThanOrEqualTo(viewIntro.mas_width);
        make.height.lessThanOrEqualTo(viewIntro.mas_height);
    }];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <= 0) {
        scrollView.backgroundColor = _leadingColor;
    } else {
        scrollView.backgroundColor = _trailingColor;
    }
}

@end
