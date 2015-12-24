//
//  MyOrderFilterStatusCell.m
//  DymIOSApp
//
//  Created by xujun on 15/11/2.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "MyOrderFilterStatusCell.h"
#import <Masonry/Masonry.h>
@interface MyOrderFilterStatusCell()
{
    ;
}
@end
@implementation MyOrderFilterStatusCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleL = [UILabel new];
        [titleL setText:@"选择状态"];
        [titleL setTextColor:[UIColor blackColor]];
        [titleL setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.height.equalTo(@20);
            
        }];
        
        _optionsButtonsView = [JPOptionButtonsView new];
//        _optionsButtonsView.backgroundColor = [UIColor redColor];
        _optionsButtonsView.tag = 999;
        [self addSubview:_optionsButtonsView];
        [_optionsButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(titleL.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.equalTo(@280);
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
