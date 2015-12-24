//
//  JPCheckButton.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPCheckButton.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"
#import "UIImage+ImageWithColor.h"

@interface JPCheckButton () {
    UIImageView     *_ivCheck;
}

@end

@implementation JPCheckButton

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
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[JPDesignSpec colorMajor] forState:UIControlStateSelected];
    
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.98 alpha:1]] forState:UIControlStateHighlighted];
    
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 2;
    
    _ivCheck = [UIImageView new];
    _ivCheck.image = [UIImage imageNamed:@"btn_correct_orange"];
    [self addSubview:_ivCheck];
    [_ivCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.trailing.equalTo(self.mas_trailing).offset(-8);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    
    self.layer.borderColor = [UIColor colorWithWhite:0 alpha:54].CGColor;
    _ivCheck.alpha = 0;
    
}

-(void)awakeFromNib {
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[JPDesignSpec colorMajor] forState:UIControlStateSelected];
}

-(void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    self.layer.borderColor = (selected ? [JPDesignSpec colorMajor] : [UIColor colorWithWhite:0 alpha:54]).CGColor;
    _ivCheck.alpha = selected ? 1 : 0;
}


@end
