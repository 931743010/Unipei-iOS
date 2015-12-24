//
//  JPAddressItemCell.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPAddressItemCell.h"
#import "JPUtils.h"
#import "JPDesignSpec.h"

@implementation JPAddressItemCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [JPUtils installBottomLine:self.containerView color:[JPDesignSpec colorGray] insets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
//    _ivEdit.hidden = YES;
//    _btnEdit.hidden = YES;
}

-(void)setChecked:(BOOL)checked {
    _ivCheck.image = [UIImage imageNamed:checked ? @"icon_checked" : @"icon_unchecked"];
    _lblCheck.text = checked ? @"已选中" : @"未选中";
}

-(void)setDefault:(BOOL)isDefault {
    _ivCheck.image = [UIImage imageNamed:isDefault ? @"icon_checked" : @"icon_unchecked"];
    _lblCheck.text = isDefault ? @"已设置为默认" : @"设为默认";
}

//-(void)layoutSubviews {
////    _lblAddress.backgroundColor = [UIColor brownColor];
//    _lblAddress.preferredMaxLayoutWidth = self.frame.size.width - 32;
//    [super layoutSubviews];
//}

@end
