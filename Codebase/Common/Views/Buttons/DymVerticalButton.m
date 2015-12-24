//
//  DymVerticalButton.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/31.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymVerticalButton.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"
#import "UIImage+ImageWithColor.h"

@interface DymVerticalButton ()

@end

@implementation DymVerticalButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit {
    
    [self setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorWhiteHighlighted]] forState:UIControlStateHighlighted];
    
    _ivLogo = [[UIImageView alloc] initWithImage:nil];
    [self addSubview:_ivLogo];
    [_ivLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.width.equalTo(@48);
        make.height.equalTo(_ivLogo.mas_width);
    }];
    
    _lblTitle = [[UILabel alloc] init];
    _lblTitle.font = [JPDesignSpec fontMenu];
    _lblTitle.textColor = [JPDesignSpec colorGrayDark];
    [self addSubview:_lblTitle];
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.ivLogo.mas_bottom).offset(5);
    }];
    
}


@end
