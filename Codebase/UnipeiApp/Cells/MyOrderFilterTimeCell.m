//
//  MyOrderFilterTimeCell.m
//  DymIOSApp
//
//  Created by xujun on 15/11/2.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "MyOrderFilterTimeCell.h"
#import <Masonry/Masonry.h>
#import "JPDatePicker.h"
#import <UnipeiApp-Swift.h>

@interface MyOrderFilterTimeCell()
@end
@implementation MyOrderFilterTimeCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *timeL = [UILabel new];
        [timeL setText:@"订单时间"];
        [timeL setTextColor:[UIColor blackColor]];
        [timeL setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:timeL];
        [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.height.equalTo(@20);
            
        }];
        
        _startTimeBtn = [UIButton new];
        _startTimeBtn.tag = 100;
        [_startTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_startTimeBtn];
        
        UILabel *lineL = [UILabel new];
        [lineL setBackgroundColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0]];
        [self addSubview:lineL];
        
        UILabel *startBtnL = [UILabel new];
        [startBtnL setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [self addSubview:startBtnL];
        
        UILabel *endBtnL = [UILabel new];
        [endBtnL setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [self addSubview:endBtnL];
        
        _endTimeBtn = [UIButton new];
        _endTimeBtn.tag = 1000;
        [_endTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_endTimeBtn];
        [_startTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).with.offset(10);
            make.top.equalTo(timeL.mas_bottom).with.offset(10);
            make.right.equalTo(lineL.mas_left);
            make.height.equalTo(@30);
            
        }];
        
        [startBtnL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).with.offset(10);
            make.top.equalTo(_startTimeBtn.mas_bottom).with.offset(5);
            make.right.equalTo(lineL.mas_left);
            make.height.equalTo(@0.5);
            
        }];
        
        [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(_startTimeBtn.mas_centerY);
            make.left.equalTo(_startTimeBtn.mas_right);
            make.right.equalTo(_endTimeBtn.mas_left);
            make.width.equalTo(@20);
            make.height.equalTo(@0.5);
            
        }];
        
        [_endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(timeL.mas_bottom).with.offset(10);
            make.left.equalTo(lineL.mas_right);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.equalTo(_startTimeBtn);
            
        }];
        
        [endBtnL mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.top.equalTo(_endTimeBtn.mas_bottom).with.offset(5);
            make.left.equalTo(lineL.mas_right);
            make.height.equalTo(startBtnL);
            make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];

        
    }
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
