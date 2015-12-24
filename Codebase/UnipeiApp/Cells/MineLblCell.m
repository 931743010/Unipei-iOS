//
//  MineLblCell.m
//  DymIOSApp
//
//  Created by xujun on 15/10/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "MineLblCell.h"
#import <Masonry/Masonry.h>

@interface MineLblCell()

@end
@implementation MineLblCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _img = [UIImageView new];
        [_img.layer setCornerRadius:10];
        [_img setImage:[UIImage imageNamed:@"1-9"]];
        [self addSubview:_img];
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.width.equalTo(@24);
            make.height.equalTo(@24);
            
        }];
        
        _lbl = [UILabel new];
        [_lbl setText:@"我的订单"];
        [_lbl setFont:[UIFont systemFontOfSize:14]];
        [_lbl setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [self addSubview:_lbl];
        [_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(_img.mas_right).with.offset(8);
            make.height.equalTo(_img);
            make.width.equalTo(@120);
            
        }];
        
        UILabel *checkLbl = [UILabel new];
        [checkLbl setText:@"查看全部订单"];
        [checkLbl setFont:[UIFont systemFontOfSize:12]];
        [checkLbl setTextColor:[UIColor colorWithRed:0x9a/255.0f green:0x9a/255.0f blue:0x9a/255.0f alpha:1]];
        [self addSubview:checkLbl];
        [checkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(-23);
            make.height.equalTo(@20);
            make.width.equalTo(@80);
            
            
        }];
        
        UIImageView *sideImg = [UIImageView new];
        [self addSubview:sideImg];
        [sideImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(checkLbl.mas_right).with.offset(8);
            make.height.equalTo(@20);
            make.width.equalTo(@10);
            
        }];
        
        UIImageView *ivRight = [UIImageView new];
        [ivRight setImage:[UIImage imageNamed:@"arrow_right"]];
        [self.contentView addSubview:ivRight];
        [ivRight mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-16);
            make.width.equalTo(@6);
            make.height.equalTo(@10);
            
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
