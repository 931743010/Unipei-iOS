//
//  OfferInquery4sCell.m
//  DymIOSApp
//
//  Created by MacBook on 12/25/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "OfferInquery4sCell.h"
#import "IPDashedLineView.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"

@implementation OfferInquery4sCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //圆角
    self.contrainerView.layer.cornerRadius = 5;
    self.contrainerView.clipsToBounds = YES;
  //设置边框
    self.contrainerView.layer.borderWidth = 1;
    self.contrainerView.layer.borderColor= [[UIColor colorWithRed:80/255 green:80/255 blue:80/255 alpha:0.2]CGColor];
    self.contrainerView.backgroundColor = [JPDesignSpec colorWhite];
    
    
    self.contentView.backgroundColor = [JPDesignSpec colorSilver];
 //设置虚线
    _lineView.lineColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    _lineView.lengthPattern = @[@2, @1];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
    }];
    
    [_lblName setContentCompressionResistancePriority:UILayoutPriorityRequired
                                              forAxis:UILayoutConstraintAxisHorizontal];
    [_lblOeno setContentCompressionResistancePriority:UILayoutPriorityRequired
                                              forAxis:UILayoutConstraintAxisHorizontal];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
