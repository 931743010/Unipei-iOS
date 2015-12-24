//
//  JPSensibleButton.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPSensibleButton.h"

@implementation JPSensibleButton

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
    _expandRatio = 0.3;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect expandRect = CGRectInset(self.bounds, -self.bounds.size.width * _expandRatio, -self.bounds.size.height * _expandRatio);
    if (CGRectContainsPoint(expandRect, point)) {
        return self;
    }
    
    return nil;
}

@end
