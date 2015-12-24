//
//  MyOrderFilterSellernameCell.m
//  DymIOSApp
//
//  Created by xujun on 15/11/3.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "MyOrderFilterSellernameCell.h"
#import <Masonry/Masonry.h>

@interface MyOrderFilterSellernameCell()<UITextFieldDelegate>
@end

@implementation MyOrderFilterSellernameCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *timeL = [UILabel new];
        [timeL setText:@"经销商名称"];
        [timeL setTextColor:[UIColor blackColor]];
        [timeL setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:timeL];
        [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.height.equalTo(@20);
            
        }];

        _sellerName = [UITextField new];
        _sellerName.delegate = self;
        _sellerName.highlighted = YES;
        [_sellerName setPlaceholder:@"请输入经销商名称"];
        [_sellerName setTextColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [_sellerName setFont:[UIFont systemFontOfSize:14]];
        [_sellerName setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_sellerName];
        
        [_sellerName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(timeL.mas_bottom).with.offset(10);
            make.left.equalTo(timeL.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-20);
            
        }];
        
        UILabel *linL = [UILabel new];
        [linL setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [self addSubview:linL];
        
        [linL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_sellerName.mas_bottom).with.offset(5);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.equalTo(@0.5);
            
        }];
        
    }
    return self;
    
}
#pragma mark -
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_sellerName resignFirstResponder];
    return  YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(endwithcurrentTextFied:)]) {
        
        [_delegate endwithcurrentTextFied:textField];
        
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
