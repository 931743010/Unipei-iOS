//
//  JPGrowingTextView.m
//  TestDynamicCell
//
//  Created by Dong Yiming on 15/10/16.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPGrowingTextView.h"
#import "JPDesignSpec.h"
#import <Masonry/Masonry.h>

@interface JPGrowingTextView () {
    CGFloat     _intrinsicHeight;
}

@end

@implementation JPGrowingTextView

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
    
    _placeHolderLeadingSpace = 8;
    
    _lblPlaceHolder = [UILabel new];
    self.font = [JPDesignSpec fontNormal];
    _lblPlaceHolder.textColor = [JPDesignSpec colorSilver];
    _lblPlaceHolder.text = @"请输入采购描述";
    [self addSubview:_lblPlaceHolder];
    [_lblPlaceHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(_placeHolderLeadingSpace);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dym_textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setPlaceHolderLeadingSpace:(CGFloat)placeHolderLeadingSpace {
    _placeHolderLeadingSpace = placeHolderLeadingSpace;
    
    [_lblPlaceHolder mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(_placeHolderLeadingSpace);
    }];
}

-(void)setFont:(UIFont *)font {
    [super setFont:font];
    _lblPlaceHolder.font = font;
    
    [self invalidateIntrinsicContentSize];
}

-(void)setText:(NSString *)text {
    [super setText:text];
    
    [self dym_textChanged:nil];
}

-(void)dym_textChanged:(NSNotification *)notification {
    
    if (self.text.length > _maxTextCount) {
        self.text = [self.text substringWithRange:NSMakeRange(0, _maxTextCount)];
    }
    
    _lblPlaceHolder.hidden = (self.text.length > 0);
    
    [self invalidateIntrinsicContentSize];
}

-(CGSize)intrinsicContentSize {
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    if (_intrinsicHeight != size.height) {
        _intrinsicHeight = size.height;
        
        if (_contentHeightChangedBlock) {
            _contentHeightChangedBlock();
        }
    }
    return CGSizeMake(UIViewNoIntrinsicMetric, _intrinsicHeight);
}

@end
