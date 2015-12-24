//
//  JPOfferItemCell.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/18.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPOfferItemCell.h"
#import "JPDesignSpec.h"
#import "JPUtils.h"
#import "UIView+TintMe.h"

@interface JPOfferItemCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation JPOfferItemCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit {
 
}

- (void)awakeFromNib {
    
    _bgView.layer.cornerRadius = 4;
    _bgView.clipsToBounds = YES;
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = [JPDesignSpec colorGray].CGColor;
    
    
    UIColor *lineColor = [JPDesignSpec colorSilver];

    CGFloat leading = [self.reuseIdentifier isEqualToString:@"JPOfferItemCell"] ? 40 : 16;
    [JPUtils installBottomLine:_lblItemCode color:lineColor insets:UIEdgeInsetsMake(0, leading, -4, 16)];
    [JPUtils installBottomLine:_lblOECode color:lineColor insets:UIEdgeInsetsMake(0, leading, -8, 16)];
    [JPUtils installBottomLine:_bgView color:lineColor insets:UIEdgeInsetsZero];
    
    //[self tintMe];
}

-(void)setChecked:(BOOL)checked {
    //icon_unchecked
    _ivCheck.image = [UIImage imageNamed:checked ? @"icon_checked" : @"icon_unchecked"];
}

-(void)setQuatationItem:(JPQuatationItem *)item {
    _quatationItem = item;
    
    self.lblItemCode.text = [NSString stringWithFormat:@"商品编号 %@", item.GoodsNO];
    self.lblItemQuality.text = [item.PartsLevel isKindOfClass:[NSString class]] ? item.PartsLevel : @"";
    self.lblItemName.text = [NSString stringWithFormat:@"%@", item.Name];
    
          //  self.lblItemName.text = @"adasdjkhasdhakjsdhkjashdkjahskdjhaskjdhkjashdkjashdjkahsjkdhakjsdhjaksdhkashdkadasdjkhasdhakjsdhkjashdkjahskdjhaskjdhkjashdkjashdjkahsjkdhakjsdhjaksdhkashdk";
    
    self.lblOECode.text = [NSString stringWithFormat:@"OE号:%@", [item.OENO isKindOfClass:[NSString class]] ? item.OENO : @""];
    self.lblOECode.lineBreakMode = NSLineBreakByCharWrapping;
    self.lblAmount.text = [NSString stringWithFormat:@"x %@", item.Num];
    self.lblBrand.text = [item.BrandName isKindOfClass:[NSString class]] ? item.BrandName : @"";
    
    //        cell.lblMarketPrice.text = [NSString stringWithFormat:@"单价:%.2f", [item.Price floatValue]];
    //        cell.lblPrice.text = [NSString stringWithFormat:@"实价:%.2f", [item.RealPrice floatValue]];
    //        cell.lblTotoalPrice.text = [NSString stringWithFormat:@"总价:%.2f", [item.TotalFee floatValue]];
    
    //        cell.lblSinglePrice.text = [NSString stringWithFormat:@"单价:￥%.2f", [item.Price doubleValue]];
    NSString *strPrice1 = [NSString stringWithFormat:@"单价:￥%.2f\n实价:￥%.2f\n", [item.Price doubleValue], [item.RealPrice doubleValue]];
    NSString *strPrice2 = [NSString stringWithFormat:@"总价:￥%.2f", [item.RealPrice doubleValue] * [item.Num integerValue]];
    NSString *strPriceFull = [NSString stringWithFormat:@"%@%@", strPrice1, strPrice2];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:strPriceFull];
    NSRange range = [strPriceFull rangeOfString:strPrice2];
    [attrStr addAttribute:NSFontAttributeName value:[JPUtils boldFont:self.lblMarketPrice.font] range:range];
    self.lblMarketPrice.attributedText = attrStr;
    
    //        cell.lblMarketPrice.text = [NSString stringWithFormat:@"单价:￥%.2f\n\n实价:￥%.2f\n\n总价:￥%.2f", [item.Price doubleValue], [item.RealPrice doubleValue], [item.RealPrice doubleValue] * [item.Num integerValue]];
    
    BOOL selected = [item.selected boolValue];
    NSLog(@"selected: %@", item.selected);
    [self setChecked:selected];
    
    //        [cell setSelectable:!_refused];
    
    self.changeNumberView.number = [item.Num integerValue];
    //        NSLog(@"cell.changeNumberView.number = %d",cell.changeNumberView.number);
    
    [self updatePreferredWidth];
}

-(void)layoutSubviews {
    [self updatePreferredWidth];
    
    [super layoutSubviews];
}

-(void)updatePreferredWidth {
    CGFloat preferedWidth = CGRectGetWidth(self.bounds);
    if (_ivCheck == nil) {
        preferedWidth -= 16 + 8 + _lblAmount.intrinsicContentSize.width + 16;
    } else {
        preferedWidth -= 16 + 8 + _changeNumberView.intrinsicContentSize.width + 16;
    }
    _lblItemName.preferredMaxLayoutWidth = preferedWidth;
}

@end
