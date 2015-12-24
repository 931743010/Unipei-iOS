//
//  UIView+Tint.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/14.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UIView+TintMe.h"

@implementation UIView (TintMe)

-(CGFloat)randomSeed {
    return (arc4random() % 128 + 127) / 255.0;
}

-(UIColor *)randomColor {
    return [UIColor colorWithRed:[self randomSeed] green:[self randomSeed] blue:[self randomSeed] alpha:0.5];
}

-(void)tintMe {
    [self tintView:self];
}

-(void)tintView:(UIView *)view {
    if (view.subviews.count > 0) {
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.backgroundColor = [self randomColor];
            
            [self tintView:obj];
        }];
    }
}

@end
