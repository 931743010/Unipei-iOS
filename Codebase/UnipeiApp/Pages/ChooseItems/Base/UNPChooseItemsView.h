//
//  UNPChooseItemsView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPSubmitButton.h"
#import "UNPTwoButtonsBarView.h"

@interface UNPChooseItemsView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UNPTwoButtonsBarView *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopViewTop;

-(void)hideBottomBar;

-(void)showTopView:(BOOL)show;

@end
