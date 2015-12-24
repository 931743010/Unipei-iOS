//
//  UNPTwoButtonsBarView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPTwoButtonsBarView.h"
#import <Masonry/Masonry.h>
#import "JPUtils.h"
#import "JPDesignSpec.h"

@implementation UNPTwoButtonsBarView

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
    _btnFirst = [JPSubmitButton new];
    _btnFirst.layer.cornerRadius = 2;
    _btnFirst.clipsToBounds = YES;
    _btnFirst.style = kJPButtonOrange;
    
    
    _btnSecond = [JPSubmitButton new];
    _btnSecond.layer.cornerRadius = 2;
    _btnSecond.clipsToBounds = YES;
    _btnSecond.style = kJPButtonWhite;
    
    [_btnFirst setTitle:@"确定" forState:UIControlStateNormal];
    [_btnSecond setTitle:@"下一步" forState:UIControlStateNormal];
    
    [_btnSecond setTitleColor:[UIColor colorWithWhite:0 alpha:0.87] forState:UIControlStateNormal];
    _btnSecond.layer.borderColor = [UIColor colorWithHex:0x9a9a9a].CGColor;
    
    [JPUtils installTopLine:self color:[UIColor colorWithWhite:0.95 alpha:1] insets:UIEdgeInsetsZero];
    
    [self showSecondButton:YES];
}

-(void)showSecondButton:(BOOL)show {
    
    [_btnFirst removeFromSuperview];
    [_btnSecond removeFromSuperview];
    
    if (show) {
        [self addSubview:_btnFirst];
        [_btnFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(16);
            make.top.equalTo(self.mas_top).offset(8);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
        }];
        
        [self addSubview:_btnSecond];
        [_btnSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing).offset(-16);
            make.top.equalTo(self.mas_top).offset(8);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
            make.width.equalTo(_btnFirst.mas_width);
            make.leading.equalTo(_btnFirst.mas_trailing).offset(8);
        }];
        
    } else {
        
        [self addSubview:_btnFirst];
        [_btnFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(8, 16, 8, 16));
        }];
    }
}



@end
