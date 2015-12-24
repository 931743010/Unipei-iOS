//
//  DymBaseVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BasicBehavior.h"

@interface DymBaseVC : UIViewController <UITextFieldDelegate, UIScrollViewDelegate
, UITableViewDataSource, UITableViewDelegate>

-(void)showEmptyView:(BOOL)show text:(NSString *)text;

-(void)showLoadingView:(BOOL)show;

@end
