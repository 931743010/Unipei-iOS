//
//  UNPChooseItemsVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"
#import "UNPChooseItemsView.h"
#import "UNPChooseItemCell.h"
#import "UNPTwoButtonsBarView.h"
#import "JPLazyBlock.h"

/// 选择itemsVC的基类
@interface UNPChooseItemsVC : DymBaseVC

@property (nonatomic, strong, readonly) UNPChooseItemsView  *rootView;

@property (nonatomic, strong, readonly) JPLazyBlock   *lazyBlock;

@end
