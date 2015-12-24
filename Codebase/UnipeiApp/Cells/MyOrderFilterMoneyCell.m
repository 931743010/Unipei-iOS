//
//  MyOrderFilterMoneyCell.m
//  DymIOSApp
//
//  Created by xujun on 15/11/3.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "MyOrderFilterMoneyCell.h"
#import <Masonry/Masonry.h>

@interface MyOrderFilterMoneyCell()<UITextFieldDelegate>
@end
@implementation MyOrderFilterMoneyCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *timeL = [UILabel new];
        [timeL setText:@"订单金额"];
        [timeL setTextColor:[UIColor blackColor]];
        [timeL setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:timeL];
        [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.height.equalTo(@20);
            
        }];
        
        _minAmount = [UITextField new];
        _minAmount.tag = 2000;
        [_minAmount setPlaceholder:@"最小金额"];
        _minAmount.keyboardType = UIKeyboardTypeNumberPad;
        [_minAmount setTextAlignment:NSTextAlignmentCenter];
        _minAmount.delegate = self;
        [_minAmount setTextColor:[UIColor colorWithWhite:0 alpha:.54]];
        [_minAmount setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_minAmount];
        
        UILabel *lineL = [UILabel new];
        [lineL setBackgroundColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0]];
        [self addSubview:lineL];
        
        UILabel *startBtnL = [UILabel new];
        [startBtnL setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [self addSubview:startBtnL];
        
        UILabel *endBtnL = [UILabel new];
        [endBtnL setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [self addSubview:endBtnL];
        
        _maxAmount = [UITextField new];
        _maxAmount.tag = 9000;
        [_maxAmount setPlaceholder:@"最大金额"];
        [_maxAmount setTextAlignment:NSTextAlignmentCenter];
        _maxAmount.delegate = self;
        _maxAmount.keyboardType = UIKeyboardTypeNumberPad;
        [_maxAmount setTextColor:[UIColor colorWithWhite:0 alpha:.54]];
        [_maxAmount setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_maxAmount];
        
        [_minAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).with.offset(10);
            make.top.equalTo(timeL.mas_bottom).with.offset(10);
            make.right.equalTo(lineL.mas_left);
            make.height.equalTo(@30);
            
        }];
        
        [startBtnL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).with.offset(10);
            make.top.equalTo(_minAmount.mas_bottom).with.offset(5);
            make.right.equalTo(lineL.mas_left);
            make.height.equalTo(@0.5);
            
        }];
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(_minAmount.mas_centerY);
            make.left.equalTo(_minAmount.mas_right);
            make.right.equalTo(_maxAmount.mas_left);
            make.width.equalTo(@20);
            make.height.equalTo(@0.5);
        }];
        
        [_maxAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(timeL.mas_bottom).with.offset(10);
            make.left.equalTo(lineL.mas_right);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.equalTo(_minAmount);
            
        }];
        
        [endBtnL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_maxAmount.mas_bottom).with.offset(5);
            make.left.equalTo(lineL.mas_right);
            make.height.equalTo(startBtnL);
            make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];

        
    }
    return self;

}
#pragma mark - 

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [_delegate canReturnWithTextField:textField];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"."]) {
        return NO;
    }
    
    return YES;
}

@end
