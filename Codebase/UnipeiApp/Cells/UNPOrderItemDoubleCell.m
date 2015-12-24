//
//  MyOrderCell.m
//  DymIOSApp
//
//  Created by xujun on 15/10/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//
#define BtnTag 100

#import "UNPOrderItemDoubleCell.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"

@interface UNPOrderItemDoubleCell() {
    MASConstraint *_constraintCancelButtonTrailing;
}
@end
@implementation UNPOrderItemDoubleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIColor *lineColor = [JPDesignSpec colorGray];
        
                ////
        
        UILabel *newLineL = [UILabel new];
        [newLineL setBackgroundColor:lineColor];
        [self addSubview:newLineL];
        [newLineL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.image.mas_bottom).with.offset(8);
            make.width.equalTo(self);
            make.height.equalTo(@0.5);
            
        }];
        
        _imgtwo = [UIImageView new];
        _imgtwo.backgroundColor = lineColor;
        [self addSubview:_imgtwo];
        [_imgtwo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(newLineL.mas_bottom).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.height.equalTo(@48);
            make.width.equalTo(@48);
            
        }];

        _nameLbltwo = [UILabel new];
        [_nameLbltwo setFont:[UIFont systemFontOfSize:14]];
        [_nameLbltwo setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [self addSubview:_nameLbltwo];
        [_nameLbltwo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_imgtwo.mas_right).with.offset(8);
            make.top.equalTo(newLineL.mas_bottom).with.offset(10);
            
        }];

        _introducetwo = [UILabel new];
        [_introducetwo setFont:[UIFont systemFontOfSize:14]];
        [_introducetwo setTextColor:[UIColor colorWithRed:0x9a/255.0f green:0x9a/255.0f blue:0x9a/255.0f alpha:1]];
        [self addSubview:_introducetwo];
        [_introducetwo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_imgtwo.mas_right).with.offset(8);
            make.top.equalTo(_nameLbltwo.mas_bottom).with.offset(4);
            
        }];

        _pricetwo = [UILabel new];
        [_pricetwo setFont:[UIFont systemFontOfSize:14]];
        [_pricetwo setTextAlignment:NSTextAlignmentRight];
        [_pricetwo setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [self addSubview:_pricetwo];
        [_pricetwo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(newLineL.mas_bottom).with.offset(10);
            make.leading.equalTo(_nameLbltwo.mas_trailing).offset(8);
            make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        [_pricetwo setContentCompressionResistancePriority:1000 forAxis:0];

        _numtwo = [UILabel new];
        [_numtwo setFont:[UIFont systemFontOfSize:12]];
        [_numtwo setTextAlignment:NSTextAlignmentRight];
        [_numtwo setTextColor:[UIColor colorWithRed:0x9a/255.0f green:0x9a/255.0f blue:0x9a/255.0f alpha:1]];
        [self addSubview:_numtwo];
        [_numtwo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_pricetwo.mas_bottom).with.offset(4);
            make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        
//        [self.contentView bringSubviewToFront:self.bottomLine];
    }
    return self;
    
}

@end
