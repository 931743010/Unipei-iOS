//
//  UIScrollView+Dym.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/17.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UIScrollView+Dym.h"

@implementation UIScrollView (Dym)

- (void)scrollToPage:(NSInteger)toIndex of:(NSInteger)ofCount {
    CGFloat pageWidth = self.contentSize.width / ofCount;
    CGFloat x = toIndex * pageWidth;
    [self setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)scrollToTop {
    [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

@end
