//
//  MyOrderFilterClearCell.m
//  DymIOSApp
//
//  Created by xujun on 15/11/2.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "MyOrderFilterClearCell.h"
#import <Masonry/Masonry.h>
@interface MyOrderFilterClearCell()
@end
@implementation MyOrderFilterClearCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setBackgroundColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0]];
        self.backgroundColor = [UIColor clearColor];
        //    清除全部选项
        _btnClearAll = [UIButton new];
        _btnClearAll.layer.cornerRadius = 2;
        _btnClearAll.clipsToBounds = YES;
        _btnClearAll.layer.borderColor = [UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1].CGColor;
        _btnClearAll.layer.borderWidth = 1;
        [_btnClearAll.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_btnClearAll setTitle:@"清除全部选项" forState:UIControlStateNormal];
        [_btnClearAll setTitleColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1] forState:UIControlStateNormal];
        [self addSubview:_btnClearAll];
        
        [_btnClearAll mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).with.offset(10);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@140);
            make.height.equalTo(@38);
            
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
