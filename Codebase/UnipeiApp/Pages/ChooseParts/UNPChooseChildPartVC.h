//
//  UNPChooseChildPartVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseItemsVC.h"
#import "UNPCarPartsChooseVM.h"

@interface UNPChooseChildPartVC : UNPChooseItemsVC

@property (nonatomic, weak) UNPCarPartsChooseVM *viewModel;

@end
