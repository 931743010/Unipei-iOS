//
//  MyOrderCellTwo.m
//  DymIOSApp
//
//  Created by xujun on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//
#define BtnTag 100

#import "UNPOrderItemCell.h"
#import "JPDesignSpec.h"

@interface UNPOrderItemCell() {
    MASConstraint *_constraintCancelButtonTrailing;
}
@end

@implementation UNPOrderItemCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIColor *lineColor = [JPDesignSpec colorGray];
        
        UIView *lightView = [UIView new];
        [lightView setBackgroundColor:[JPDesignSpec colorSilver]];
        [self addSubview:lightView];
        [lightView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self);
            make.height.equalTo(@8);
            make.width.equalTo(self);
            
        }];
        
        ////
        _img = [UIImageView new];
        [_img setImage:[UIImage imageNamed:@"icon_order_dealer"]];
        [self addSubview:_img];
        
        _venderName = [UILabel new];
        [_venderName setFont:[UIFont systemFontOfSize:14]];
        [_venderName setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [self addSubview:_venderName];
        
        _statusLbl = [UILabel new];
        [_statusLbl setFont:[UIFont systemFontOfSize:14]];
        [_statusLbl setTextAlignment:NSTextAlignmentRight];
        [_statusLbl setTextColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [self addSubview:_statusLbl];


        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lightView.mas_bottom).with.offset(14);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            
        }];
        
        [_venderName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lightView.mas_bottom).with.offset(14);
            make.left.equalTo(_img.mas_right).with.offset(8);
            make.right.equalTo(_statusLbl.mas_left);
            
        }];
        
        [_statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lightView.mas_bottom).with.offset(14);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.leading.equalTo(_venderName.mas_trailing).with.offset(8); //
            
        }];
        [_statusLbl setContentCompressionResistancePriority:1000 forAxis:0];

        _lineLone = [UILabel new];
        [_lineLone setBackgroundColor:[JPDesignSpec colorMajor]];
        [self addSubview:_lineLone];
        [_lineLone mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).with.offset(48);
            make.width.equalTo(self);
            make.height.equalTo(@0.5);
            
        }];
        
        ////
        _image = [UIImageView new];
        _image.backgroundColor = lineColor;
        [self addSubview:_image];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_lineLone.mas_bottom).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.height.equalTo(@48);
            make.width.equalTo(@48);
            
        }];
        
        _nameLbl = [UILabel new];
        [_nameLbl setFont:[UIFont systemFontOfSize:14]];
        [_nameLbl setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [self addSubview:_nameLbl];
        [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_image.mas_right).with.offset(8);
            make.top.equalTo(_lineLone.mas_bottom).with.offset(10);
            
        }];
        
        _introduce = [UILabel new];
        [_introduce setFont:[UIFont systemFontOfSize:14]];
        [_introduce setTextColor:[UIColor colorWithRed:0x9a/255.0f green:0x9a/255.0f blue:0x9a/255.0f alpha:1]];
        [self addSubview:_introduce];
        [_introduce mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_image.mas_right).with.offset(8);
            make.top.equalTo(_nameLbl.mas_bottom).with.offset(4);
            
        }];
        
        _price = [UILabel new];
        [_price setFont:[UIFont systemFontOfSize:14]];
        [_price setTextAlignment:NSTextAlignmentRight];
        [_price setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [self addSubview:_price];
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_lineLone.mas_bottom).with.offset(10);
            make.leading.equalTo(_nameLbl.mas_trailing).offset(8);
            make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        [_price setContentCompressionResistancePriority:1000 forAxis:0];
        
        _num = [UILabel new];
        [_num setFont:[UIFont systemFontOfSize:12]];
        [_num setTextAlignment:NSTextAlignmentRight];
        [_num setTextColor:[UIColor colorWithRed:0x9a/255.0f green:0x9a/255.0f blue:0x9a/255.0f alpha:1]];
        [self addSubview:_num];
        [_num mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_price.mas_bottom).with.offset(4);
            make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        
        _lineLtwo = [UILabel new];
        [_lineLtwo setBackgroundColor:lineColor];
        [self addSubview:_lineLtwo];
        [_lineLtwo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            _lineLtwoTopConstraint = make.top.equalTo(_image.mas_bottom).with.offset(8);
            make.width.equalTo(self);
            make.height.equalTo(@0.5);
            
        }];
        
        ////
        _totaltext = [UILabel new];
        [_totaltext setText:@"合计:"];
        [_totaltext setTextAlignment:NSTextAlignmentRight];
        [_totaltext setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [_totaltext setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_totaltext];
        
        _totalprice = [UILabel new];
        [_totalprice setTextAlignment:NSTextAlignmentRight];
        [_totalprice setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [_totalprice setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_totalprice];
        
        [_totaltext mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_lineLtwo.mas_bottom).with.offset(14);
            make.right.equalTo(_totalprice.mas_left).with.offset(-10);
            
        }];
        
        [_totalprice mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.top.equalTo(_lineLtwo.mas_bottom).with.offset(14);
            
        }];
        
        UILabel *lineLthr = [UILabel new];
        [lineLthr setBackgroundColor:lineColor];
        [self addSubview:lineLthr];
        [lineLthr mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_totalprice.mas_bottom).with.offset(14);
            make.height.equalTo(@0.5);
            make.width.equalTo(self);
            
        }];

        _btnOne = [UIButton new];
        [_btnOne.layer setCornerRadius:5];
        [_btnOne.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_btnOne setTitle:@"订单跟踪" forState:UIControlStateNormal];
        [_btnOne setTitleColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1] forState:UIControlStateNormal];
        [_btnOne.layer setBorderColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1].CGColor];
        [_btnOne.layer setBorderWidth:1];
        [self addSubview:_btnOne];
        
        _btnTwo = [UIButton new];
        [_btnTwo.layer setCornerRadius:5];
        [_btnTwo.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [_btnTwo setTitle:@"订单跟踪" forState:UIControlStateNormal];
        [_btnTwo setTitleColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1] forState:UIControlStateNormal];
        [_btnTwo.layer setBorderColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1].CGColor];
        [_btnTwo.layer setBorderWidth:1];
        [self addSubview:_btnTwo];
        
        [_btnOne mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lineLthr.mas_bottom).with.offset(8);
            make.right.equalTo(_btnTwo.mas_left).with.offset(-10);
            make.width.equalTo(@80);
            make.height.equalTo(@32);
            
        }];
        
        [_btnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lineLthr.mas_bottom).with.offset(8);
            _constraintCancelButtonTrailing = make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.equalTo(_btnOne);
            make.width.equalTo(_btnOne);
            
        }];

        
    }
    return self;
    
}

-(void)showCancelButton:(BOOL)show {
    _btnTwo.hidden = !show;
    _constraintCancelButtonTrailing.offset = show ? -10 : 80;
}

@end
