//
//  JPLoadingView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/29.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPLoadingView : UIView

@property (nonatomic, strong, readonly) UIImageView     *ivLogo;

-(void)show:(BOOL)show;

@end
