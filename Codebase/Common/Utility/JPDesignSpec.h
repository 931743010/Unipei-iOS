//
//  JPDesignSpec.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/31.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EDColor/EDColor.h>

@interface JPDesignSpec : NSObject

#pragma mark - Colors
+(UIColor *)colorMajor;
+(UIColor *)colorMajorHighlighted;
+(UIColor *)colorMinor;
+(UIColor *)colorBlack;
+(UIColor *)colorGrayDark;
+(UIColor *)colorGray;
+(UIColor *)colorSilver;
+(UIColor *)colorWhiteDark;
+(UIColor *)colorWhiteHighlighted;
+(UIColor *)colorWhite;


#pragma mark - Fonts
+(UIFont *)fontHeaderLarge;
+(UIFont *)fontHeader;
+(UIFont *)fontHeaderMinor;
+(UIFont *)fontNormal;
+(UIFont *)fontSub;
+(UIFont *)fontMenu;
+(UIFont *)fontButton;

@end
