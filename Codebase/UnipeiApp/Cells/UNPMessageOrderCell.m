//
//  UNPSystemMessageCell.m
//  DymIOSApp
//
//  Created by xujun on 15/11/16.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPMessageOrderCell.h"
#import "JPUtils.h"

@implementation UNPMessageOrderCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.lblMessageTitle.backgroundColor = [UIColor clearColor];
    
    [JPUtils installBottomLine:self.lblClassify color:[UIColor colorWithWhite:0.9 alpha:1] insets:UIEdgeInsetsMake(-8, 4, 0, 4)];
}

@end
