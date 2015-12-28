//
//  JPButton.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/1.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EJPButtonStyle) {
    kJPButtonOrange
    , kJPButtonWhite
};

// 由你配UI设计规范按钮
@interface JPSubmitButton : UIButton

@property (assign, nonatomic) EJPButtonStyle     style;

-(instancetype)initWithStyle:(EJPButtonStyle)style;

@end
