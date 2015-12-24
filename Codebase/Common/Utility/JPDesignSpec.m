//
//  JPDesignSpec.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/31.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPDesignSpec.h"


#define FONT_NAME_HELVETICA             @"HelveticaNeue"
#define FONT_NAME_HELVETICA_MEDIUM      @"HelveticaNeue-Medium"
#define FONT_NAME_HELVETICA_LIGHT       @"HelveticaNeue-Light"

@implementation JPDesignSpec


#pragma mark - Colors
+(UIColor *)colorMajor {
    return [UIColor colorWithHex:0xf27300];
}

+(UIColor *)colorMajorHighlighted {
    return [UIColor colorWithHex:0xf28824];
}

+(UIColor *)colorMinor {
    return [UIColor colorWithHex:0x00a2c8];
}

+(UIColor *)colorBlack {
    return [UIColor colorWithHex:0x000000 andAlpha:0.87];
}

+(UIColor *)colorGrayDark {
    return [UIColor colorWithHex:0x000000 andAlpha:0.54];
}

+(UIColor *)colorGray {
    return [UIColor colorWithHex:0xdedede];
}

+(UIColor *)colorSilver {
    return [UIColor colorWithHex:0xeeeeee];
}

+(UIColor *)colorWhiteDark {
    return [UIColor colorWithHex:0xfafafa];
}

+(UIColor *)colorWhiteHighlighted {
    return [UIColor colorWithHex:0xf2f2f2];
}

+(UIColor *)colorWhite {
    return [UIColor colorWithHex:0xffffff];
}




#pragma mark - Fonts
+(UIFont *)fontHeaderLarge {
    return [UIFont fontWithName:FONT_NAME_HELVETICA size:24];
}

+(UIFont *)fontHeader {
    return [UIFont fontWithName:FONT_NAME_HELVETICA_MEDIUM size:20];
}

+(UIFont *)fontHeaderMinor {
    return [UIFont fontWithName:FONT_NAME_HELVETICA size:16];
}

+(UIFont *)fontNormal {
    return [UIFont fontWithName:FONT_NAME_HELVETICA size:14];
}

+(UIFont *)fontSub {
    return [UIFont fontWithName:FONT_NAME_HELVETICA size:12];
}

+(UIFont *)fontMenu {
    return [UIFont fontWithName:FONT_NAME_HELVETICA_MEDIUM size:14];
}

+(UIFont *)fontButton {
    return [UIFont fontWithName:FONT_NAME_HELVETICA_MEDIUM size:16];
}



@end
