//
//  JPRedDotView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/24.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "JPRedDotView.h"
#import <Masonry/Masonry.h>

static CGFloat dotRadius = 2;

@implementation JPRedDotView


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

    self.backgroundColor = [UIColor redColor];
    
    _radius = dotRadius;
    self.layer.cornerRadius = _radius;
}

#pragma mark -
-(void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.layer.cornerRadius = _radius;
}

-(void)installTo:(UIView *)hostView {
    if (hostView) {
        [hostView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(hostView.mas_trailing).offset(_offset.x);
            make.top.equalTo(hostView.mas_top).offset(_offset.y);;
            make.width.height.equalTo(@(_radius * 2));
        }];
    }
}

@end
