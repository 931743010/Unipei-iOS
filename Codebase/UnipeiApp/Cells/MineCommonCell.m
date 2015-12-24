//
//  MineCommonCell.m
//  DymIOSApp
//
//  Created by xujun on 15/10/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "MineCommonCell.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"

@interface MineCommonCell()
@end
@implementation MineCommonCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _img = [UIImageView new];
        [_img.layer setCornerRadius:10];
        [self addSubview:_img];
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.width.equalTo(@24);
            make.height.equalTo(@24);
            
        }];
        
        _lbl = [UILabel new];
        [_lbl setFont:[UIFont systemFontOfSize:14]];
        [_lbl setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [self addSubview:_lbl];
        [_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(_img.mas_right).with.offset(8);
            make.height.equalTo(_img);
            make.width.equalTo(@120);
            
        }];
        
        UIImageView *sideImg = [UIImageView new];
        [self addSubview:sideImg];
        [sideImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.height.equalTo(@20);
            make.width.equalTo(@10);
            
        }];

        
        UILabel *linelbl = [UILabel new];
        [linelbl setBackgroundColor:[JPDesignSpec colorGray]];
        [self addSubview:linelbl];
        [linelbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@0.5);
            make.leading.trailing.equalTo(self);
            
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


@end
