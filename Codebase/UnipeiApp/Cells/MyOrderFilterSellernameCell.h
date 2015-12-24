//
//  MyOrderFilterSellernameCell.h
//  DymIOSApp
//
//  Created by xujun on 15/11/3.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLinedTableCell.h"

@protocol MyOrderFilterSellernameCell<NSObject>
-(void)endwithcurrentTextFied :(UITextField *)currentTextFied;
@end

@interface MyOrderFilterSellernameCell : JPLinedTableCell
@property (nonatomic,strong) UITextField *sellerName;
@property (nonatomic,assign) id<MyOrderFilterSellernameCell>delegate;
@end
