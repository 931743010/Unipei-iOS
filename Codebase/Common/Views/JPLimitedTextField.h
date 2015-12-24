//
//  JPLimitedTextField.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/9.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPLimitedTextField : UITextField

/// 最大输入字符数
@property (nonatomic, assign) NSUInteger        maxLength;

@end
