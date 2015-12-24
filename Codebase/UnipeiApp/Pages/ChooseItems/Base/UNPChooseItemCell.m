//
//  UNPChooseItemCell.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseItemCell.h"
#import "JPUtils.h"

@implementation UNPChooseItemCell

- (void)awakeFromNib {
    
    [JPUtils installBottomLine:self.contentView color:[UIColor colorWithWhite:0.95 alpha:1] insets:UIEdgeInsetsZero];
}

@end
