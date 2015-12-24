//
//  UNPChooseProvinceVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseItemsVC.h"
#import "UNPAddressChooseVM.h"

@interface UNPChooseProvinceVC : UNPChooseItemsVC

/// Passed in from outside
@property (nonatomic, strong) UNPAddressChooseVM     *viewModel;

@end
