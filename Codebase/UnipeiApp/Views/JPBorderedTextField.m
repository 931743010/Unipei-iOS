//
//  JPBorderedTextField.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/25.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "JPBorderedTextField.h"
#import <Masonry/Masonry.h>
#import "UIView+TintMe.h"

@implementation JPBorderedTextField

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
    _textField = [UITextField new];
    _textField.font = [UIFont systemFontOfSize:14];
    [self addSubview:_textField];
    
    _rightButton = [UIButton new];
    UIImage *image = [UIImage imageNamed:@"icon_scan"];
    [_rightButton setImage:image forState:UIControlStateNormal];
    [self addSubview:_rightButton];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailingMargin);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_rightButton setContentCompressionResistancePriority:1000 forAxis:0];
    [_rightButton setContentHuggingPriority:1000 forAxis:0];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self).insets(UIEdgeInsetsMake(8, 8, 8, 8));
        make.leading.equalTo(self.mas_leadingMargin);
        make.trailing.equalTo(_rightButton.mas_leading).offset(-8);
    }];
    
    self.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
    
//    [self tintMe];
}

@end
