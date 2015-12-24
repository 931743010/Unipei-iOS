//
//  JPChangeNumberView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPChangeNumberView.h"
#import "JPSensibleButton.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JPDesignSpec.h"
#import "JPLazyBlock.h"

static CGFloat const BUTTON_SIZE = 24;

@interface JPChangeNumberView () {
    JPSensibleButton    *_increaseButton;
    JPSensibleButton    *_decreaseButton;
    UILabel             *_numberLabel;
    
    JPLazyBlock         *_lazyBlock;
}

@end



@implementation JPChangeNumberView

-(void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

-(void)setNumber:(NSInteger)number {
    _number = number;
    
    _numberLabel.text = [NSString stringWithFormat:@"%@", @(_number)];
}

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
    
    _lazyBlock = [JPLazyBlock new];
    
    _increaseButton = [JPSensibleButton new];
    _increaseButton.expandRatio = 0.5;
    
    _numberLabel = [UILabel new];
    
    _decreaseButton = [JPSensibleButton new];
    _decreaseButton.expandRatio = 0.5;
    
    //
    [_increaseButton setImage:[UIImage imageNamed:@"btn_circle_add_gray"] forState:UIControlStateNormal];
    [self addSubview:_increaseButton];
    [_increaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.and.bottom.equalTo(self);
        make.width.and.height.equalTo(@(BUTTON_SIZE));
    }];
    
    //
    [_decreaseButton setImage:[UIImage imageNamed:@"btn_circle_minus_gray"] forState:UIControlStateNormal];
    [self addSubview:_decreaseButton];
    [_decreaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.bottom.equalTo(self);
        make.width.and.height.equalTo(@(BUTTON_SIZE));
    }];
    
    //
    _numberLabel.textColor = [UIColor blackColor];
    _numberLabel.font = [JPDesignSpec fontNormal];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_decreaseButton.mas_trailing);
        make.trailing.equalTo(_increaseButton.mas_leading);
        make.width.greaterThanOrEqualTo(@40);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.number = 0;
    
    //
    @weakify(self)
    UIControlEvents events =  UIControlEventTouchDown;
    
    [[_increaseButton rac_signalForControlEvents:events] subscribeNext:^(id x) {
        @strongify(self)
        self.number = self.number + 1;
        
        if (self.numberChangedBlock) {
            self.numberChangedBlock(self.number);
        }
    }];
    
    [[_decreaseButton rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        @strongify(self)
        self.number = self.number - 1;
        
        if (self.numberChangedBlock) {
            self.numberChangedBlock(self.number);
        }
        
//        @weakify(self)
//        [self->_lazyBlock excuteBlock:^{
//            @strongify(self)
//            if (self.numberChangedBlock) {
//                self.numberChangedBlock(self.number);
//            }
//        }];
    }];
    
    [RACObserve(self, number) subscribeNext:^(id x) {
        @strongify(self)
        self->_decreaseButton.enabled = ([x integerValue] > 1);
    }];
}

-(CGSize)intrinsicContentSize {
    CGFloat height = BUTTON_SIZE;
    CGFloat width = BUTTON_SIZE + [_numberLabel intrinsicContentSize].width + BUTTON_SIZE;
    
    return CGSizeMake(width, height);
}

@end
