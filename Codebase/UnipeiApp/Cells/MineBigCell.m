//
//  MineBigCell.m
//  DymIOSApp
//
//  Created by xujun on 15/10/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//
#define BtnTag 100

#import "MineBigCell.h"
#import <Masonry/Masonry.h>
#import "XMBadgeView.h"
#import "JPUtils.h"

@interface MineBigCell()
{
    NSArray *_btnImageName;
    NSArray *_btnLblText;
    
    NSMutableArray  *_buttons;
}
@property (nonatomic, copy) NSArray *buttonValues;
@end


@implementation MineBigCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _btnImageName = @[@"1-1",@"1-3",@"2-3",@"2-2"];
    _btnLblText = @[@"待发货",@"待收货",@"已收货",@"已取消"];
    _buttonValues = @[@(kJPOrderStatusWaitingForShipping), @(kJPOrderStatusWaitingForReceival), @(kJPOrderStatusReceived), @(kJPOrderStatusCancelled)];
    _buttons = [NSMutableArray array];
    ///
    if (self) {
        
        UIView *container = [UIView new];
        [self addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
            make.width.equalTo(self);
            
        }];
        
        UIButton *lastBtn = nil;
        for (int i = 0; i < _buttonValues.count; i ++) {
            
            CellBtn *button = [CellBtn new];
            [_buttons addObject:button];
            
            button.tag = [_buttonValues[i] integerValue];
            button.btnImage.image = [UIImage imageNamed:_btnImageName[i]];
            button.btnLbl.text = _btnLblText[i];
            [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

            [container addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(self.mas_centerY);
                make.width.mas_equalTo(container.mas_width).multipliedBy(0.25);
                make.height.equalTo(container);
                
                if (lastBtn) {
                    
                    make.left.equalTo(lastBtn.mas_right).with.offset(0);
                    
                }else{
                
                    make.left.equalTo(container.mas_left);
                
                }
                
            }];
            
            lastBtn = button;
        }
                
    }
    return self;
    
}

-(void)setBadgeNumber:(NSUInteger)number forValue:(NSInteger)value {
    [_buttons enumerateObjectsUsingBlock:^(CellBtn * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == value) {
            [obj setBadgeNumber:number];
            *stop = YES;
        }
    }];
}

-(void)btnAction : (UIButton *)b{
    
//    NSInteger i = b.tag - BtnTag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectBtn:)]) {
        
        [_delegate selectBtn:b.tag];
        
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
