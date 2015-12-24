//
//  UNPChooseSeriesVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseItemsVC.h"
#import "UNPCarModelChooseVM.h"

/// 选择车系
@interface UNPChooseSeriesVC : UNPChooseItemsVC

/// Passed in from outside
@property (nonatomic, weak) UNPCarModelChooseVM     *viewModel;

@end
