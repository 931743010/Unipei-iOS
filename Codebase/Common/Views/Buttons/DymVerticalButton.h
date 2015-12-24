//
//  DymVerticalButton.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/31.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 图片在上，文字在下的按钮
@interface DymVerticalButton : UIButton

@property (strong, nonatomic)  UIImageView  *ivLogo;
@property (strong, nonatomic)  UILabel      *lblTitle;

@end
