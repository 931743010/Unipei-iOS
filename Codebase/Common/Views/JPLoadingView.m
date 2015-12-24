//
//  JPLoadingView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/29.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPLoadingView.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"
#import "DGActivityIndicatorView.h"

@interface JPLoadingView () {
    DGActivityIndicatorView     *_indicatorView;
}

@end

@implementation JPLoadingView

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
    self.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    _ivLogo = [UIImageView new];
    _ivLogo.image = [UIImage imageNamed:@"icon_logo_gray"];
    [self addSubview:_ivLogo];
    [_ivLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(-50);
        make.width.and.height.equalTo(@40);
    }];
    
    
    _indicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallPulse
                                                         tintColor:[JPDesignSpec colorMinor] size:40.0f];
    [self addSubview:_indicatorView];
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_ivLogo.mas_bottom).offset(0);
    }];
//    _lblMessage.text = @"暂无数据";
}

-(void)show:(BOOL)show {
    self.hidden = !show;
    
    if (show) {
        [self.superview bringSubviewToFront:self];
        [_indicatorView startAnimating];
    } else {
        [self.superview sendSubviewToBack:self];
        [_indicatorView stopAnimating];
    }
}

@end
