//
//  JPLinedTableCell.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/8.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 上下有线的cell
@interface JPLinedTableCell : UITableViewCell

@property (nonatomic, strong) UIView    *topLine;
@property (nonatomic, strong) UIView    *bottomLine;

@end
