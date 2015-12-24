//
//  UNPChooseItemsView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseItemsView.h"
#import "JPUtils.h"
#import "JPDesignSpec.h"

@implementation UNPChooseItemsView

-(void)awakeFromNib {
    
    _tableView.backgroundColor = [JPDesignSpec colorSilver];
    _topView.backgroundColor = [UIColor whiteColor];
    
}

-(void)hideBottomBar {
    [_bottomBar removeFromSuperview];
    _constraintTableViewBottom.constant = 0;
}

-(void)showTopView:(BOOL)show {
    _constraintTopViewTop.constant = show ? 0 : -56;
    _topView.hidden = !show;
}

@end
