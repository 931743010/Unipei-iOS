//
//  JPIconTextButton.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPIconTextButton.h"
#import "JPDesignSpec.h"

@implementation JPIconTextButton

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
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[JPDesignSpec colorMajor] forState:UIControlStateHighlighted];
    [self setTitleColor:[JPDesignSpec colorMajor] forState:UIControlStateSelected];
}

@end
