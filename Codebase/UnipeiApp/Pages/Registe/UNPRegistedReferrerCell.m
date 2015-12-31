//
//  UNPRegistedReferrerCell.m
//  DymIOSApp
//
//  Created by xujun on 15/12/24.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPRegistedReferrerCell.h"

@implementation UNPRegistedReferrerCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *buttons = @[_btnDealer, _btnSalesman];
    [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setImage:[UIImage imageNamed:@"icon_radio_unselected"] forState:UIControlStateNormal];
        [obj setImage:[UIImage imageNamed:@"icon_radio_selected"] forState:UIControlStateSelected];
    }];
}


@end
