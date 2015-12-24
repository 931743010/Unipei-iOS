//
//  JPPickerButton.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPPickerButton.h"
#import <Masonry/Masonry.h>

@interface JPPickerButton () {
    UIImageView     *_ivMark;
}

@end

@implementation JPPickerButton

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
    
    _ivMark = [UIImageView new];
    _ivMark.image = [UIImage imageNamed:@"arrow_down_gray"];
    [self addSubview:_ivMark];
    [_ivMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(self.mas_trailing).offset(2);
        make.width.equalTo(@10);
        make.height.equalTo(@6);
    }];
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self layoutIfNeeded];
}

-(CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += 20;
    return size;
}

@end
