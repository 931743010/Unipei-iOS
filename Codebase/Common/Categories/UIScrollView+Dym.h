//
//  UIScrollView+Dym.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/17.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Dym)

- (void)scrollToPage:(NSInteger)toIndex of:(NSInteger)ofCount;

- (void)scrollToTop;

@end
