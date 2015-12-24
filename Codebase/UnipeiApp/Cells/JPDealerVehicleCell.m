//
//  JPDealerVehicleCell.m
//  DymIOSApp
//
//  Created by MacBook on 11/18/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "JPDealerVehicleCell.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"
#import "JPDealerConstants.h"


@implementation JPDealerVehicleCell
{
//    UIView *_rightView;
}


- (void)createSubviews {
    _imageView1 = [UIImageView new];
    //        [_imageView1.layer setCornerRadius:5];
    
    _imageView1.clipsToBounds = YES;
    _imageView1.layer.cornerRadius = 5.0;
    
    _dealerName = [UILabel new];
    _dealerName.lineBreakMode = NSLineBreakByWordWrapping;
    [_dealerName setNumberOfLines:0];
    [_dealerName setFont:[UIFont systemFontOfSize:15.0f]];
    [_dealerName setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
    
    _rating = [[AXRatingView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    _rating.baseColor = [JPDesignSpec colorGray];
    
    _brand = [UILabel new];
    _brand.lineBreakMode = NSLineBreakByWordWrapping;
    [_brand setNumberOfLines:0];
    _brand.tag = 1001;
    [_brand setFont:[UIFont systemFontOfSize:kBrandFontSize]];
    [_brand setTextColor:[UIColor grayColor]];
    
    [self updateMaxLayoutLength];
    
    [self.contentView addSubview:_imageView1];
    [self.contentView addSubview:_dealerName];
    [self.contentView addSubview:_rating];
    [self.contentView addSubview:_brand];
    
//    _dealerName.backgroundColor = [UIColor redColor];
//    _rating.backgroundColor = [UIColor redColor];
//    _brand.backgroundColor = [UIColor redColor];
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createSubviews];

        
//        _rightView = [UIView new];
//        [self addSubview:_rightView];
        
        
//        [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).offset(8);
//            make.trailing.equalTo(self.mas_trailing);
//            make.bottom.equalTo(self.mas_bottom).offset(-8);
//            make.leading.equalTo(_imageView1.mas_trailing).offset(10);
//            make.centerY.equalTo(self.mas_centerY);
//        }];
        
        
        
        
//        [_rightView addSubview:_dealerName];
//        [_rightView addSubview:_rating];
//        [_rightView addSubview:_brand];
        
        
        ///
        [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@60);
            make.height.equalTo(@60);
            make.centerY.equalTo(self.mas_centerY);
            make.leading.equalTo(self.mas_leading).with.offset(16);
        }];

        
 
         [_dealerName mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.contentView.mas_top).with.offset(4);
         make.leading.equalTo(_imageView1.mas_trailing).with.offset(8);
         make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-16);
         }];
        [_dealerName setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];

        
         [_rating mas_makeConstraints:^(MASConstraintMaker *make) {
             make.height.equalTo(@30);
             make.width.equalTo(@120);
             make.top.equalTo(_dealerName.mas_bottom).with.offset(4);
             make.leading.equalTo(_dealerName.mas_leading);
         }];
        [_rating setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];

        
        
        [_brand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rating.mas_bottom).with.offset(8);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8);
//            make.leading.trailing.equalTo(_rightView);
            make.leading.equalTo(_dealerName.mas_leading);
            make.trailing.equalTo(_dealerName.mas_trailing);
        }];
         [_brand setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];

    }
    return self;
    
}

-(void)updateMaxLayoutLength {
    CGFloat width = CGRectGetWidth(self.bounds);
    _brand.preferredMaxLayoutWidth = width - 100;
    _dealerName.preferredMaxLayoutWidth = _brand.preferredMaxLayoutWidth;
}

-(void)layoutSubviews {
    
    [self updateMaxLayoutLength];
    
    [super layoutSubviews];
}

@end
