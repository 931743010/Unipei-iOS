//
//  UNPTwoButtonsBarView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPSubmitButton.h"

@interface UNPTwoButtonsBarView : UIView

@property (nonatomic, strong) JPSubmitButton    *btnFirst;
@property (nonatomic, strong) JPSubmitButton    *btnSecond;

-(void)showSecondButton:(BOOL)show;

@end
