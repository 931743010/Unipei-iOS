//
//  OfferInquery4sHeaderView.m
//  DymIOSApp
//
//  Created by MacBook on 12/27/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "OfferInquery4sHeaderView.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"

@implementation OfferInquery4sHeaderView

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
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.frame = CGRectMake(0, 0, frame.size.width, 44);
    self.backgroundColor = [JPDesignSpec colorSilver];
    _lblCarName = [UILabel new];
    _lblCarName.font = [UIFont systemFontOfSize:14];
    _lblCarName.lineBreakMode = NSLineBreakByWordWrapping;
    _lblCarName.numberOfLines = 0;
    [self addSubview:_lblCarName];

    [_lblCarName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(16);
        make.trailing.equalTo(self.mas_trailing);
        make.centerY.equalTo(self.mas_centerY);
    }];

}



- (void)drawRect:(CGRect)rect {

}


@end
