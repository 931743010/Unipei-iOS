//
//  JPInquiryDealerCell.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/16.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPInquiryDealerCell.h"
#import "JPDesignSpec.h"
//#import <Masonry/Masonry.h>
#import "JPUtils.h"

@implementation JPInquiryDealerCell

- (void)awakeFromNib {

    UIColor *lineColor = [JPDesignSpec colorSilver];

    [JPUtils installBottomLine:_lblDealerName color:lineColor insets:UIEdgeInsetsMake(0, 16, -8, 16)];
    [JPUtils installBottomLine:_btnCheck color:lineColor insets:UIEdgeInsetsMake(0, 16, -10, 16)];
    
    lineColor = [JPDesignSpec colorGray];
    [JPUtils installBottomLine:self.contentView color:lineColor insets:UIEdgeInsetsZero];
    
//    [self updatePreferredWidths];
}

//-(void)layoutSubviews {
//    [self updatePreferredWidths];
//    
//    [super layoutSubviews];
//}

//-(void)updatePreferredWidths {
//    CGFloat width = CGRectGetWidth(self.bounds);
//    
//    _lblDealerName.preferredMaxLayoutWidth = width - 116;
//}

@end
