//
//  MoreCell.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/23.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "MoreCell.h"
@interface MoreCell()

@end
@implementation MoreCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.moreButton.layer.cornerRadius = 5;
    self.moreButton.clipsToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
