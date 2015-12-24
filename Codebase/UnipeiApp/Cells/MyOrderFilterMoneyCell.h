//
//  MyOrderFilterMoneyCell.h
//  DymIOSApp
//
//  Created by xujun on 15/11/3.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLinedTableCell.h"

@protocol MyOrderFilterMoneyCellDelegate<NSObject>
@required
-(BOOL)canReturnWithTextField :(UITextField *)currentTextField;
@end

@interface MyOrderFilterMoneyCell : JPLinedTableCell
@property (nonatomic,strong) UITextField *minAmount;
@property (nonatomic,strong) UITextField *maxAmount;
@property (nonatomic,assign) id<MyOrderFilterMoneyCellDelegate>delegate;
@end
