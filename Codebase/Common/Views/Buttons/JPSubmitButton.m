//
//  JPButton.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/1.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPSubmitButton.h"
#import "UIImage+ImageWithColor.h"
#import "JPDesignSpec.h"

@interface JPSubmitButton ()
@end

@implementation JPSubmitButton

-(instancetype)initWithStyle:(EJPButtonStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setStyle:style];
        [self doInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}


-(void)doInit {
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    
    self.titleLabel.font = [JPDesignSpec fontButton];
}

-(void)setStyle:(EJPButtonStyle)style {
    _style = style;
    
    if (style == kJPButtonOrange) {
        [self setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorMajor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorMajorHighlighted]] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorMajorHighlighted]] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorGray]] forState:UIControlStateDisabled];
        
        [self setTitleColor:[JPDesignSpec colorWhite] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHex:0xbcbcbc] forState:UIControlStateDisabled];
        
    } else if (style == kJPButtonWhite) {
        
        [self setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorWhite]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorWhiteHighlighted]] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorWhiteHighlighted]] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorGray]] forState:UIControlStateDisabled];
        
        [self setTitleColor:[JPDesignSpec colorMajor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHex:0xbcbcbc] forState:UIControlStateDisabled];
        
        self.layer.borderColor = [JPDesignSpec colorMajor].CGColor;
        self.layer.borderWidth = 0.5;
    }
}

@end
