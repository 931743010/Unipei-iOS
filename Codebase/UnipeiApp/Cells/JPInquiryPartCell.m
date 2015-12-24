//
//  JPInquiryPartCell.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPInquiryPartCell.h"
#import "JPDesignSpec.h"
#import <Masonry/Masonry.h>
#import "JPUtils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UNPCarPartsChooseVM.h"

@interface JPInquiryPartCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end


@implementation JPInquiryPartCell

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
    _amount = 1;
}

-(void)setAmount:(NSInteger)amount {
    _amount = amount;
    _changeNumberView.number = _amount;
    
    _inquiryPart.number = @(amount);
    
    [self updateAmountLabel];
}

-(void)updateAmountLabel {
    
    _lblAmmount.text = [NSString stringWithFormat:@"X%@", @(_amount)];
}

- (void)awakeFromNib {
    
    _bgView.layer.cornerRadius = 4;
    _bgView.clipsToBounds = YES;
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = [JPDesignSpec colorGray].CGColor;
    
    UIColor *lineColor = [JPDesignSpec colorSilver];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, -8, 16);
    [JPUtils installBottomLine:_lblBaseCategory color:lineColor insets:insets];
    [JPUtils installBottomLine:_lblSubCategory color:lineColor insets:insets];
    [JPUtils installBottomLine:_lblStandardName color:lineColor insets:insets];
    
    @weakify(self)
    _changeNumberView.numberChangedBlock = ^void(NSInteger number) {
        @strongify(self)
        self.amount = number;
    };
}

-(void)setInquiryPart:(UNPInquiryPart *)inquiryPart {
    _inquiryPart = inquiryPart;
    
    self.lblBaseCategory.text = _inquiryPart.maincategory;
    self.lblSubCategory.text = _inquiryPart.subcategory;
    self.lblStandardName.text = _inquiryPart.leafcategory;
    self.amount = [_inquiryPart.number integerValue];
}

@end
