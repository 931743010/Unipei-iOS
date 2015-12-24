//
//  MyOrderCellTwo.h
//  DymIOSApp
//
//  Created by xujun on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "JPLinedTableCell.h"
@interface UNPOrderItemCell : JPLinedTableCell
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *venderName;
@property (nonatomic,strong) UIImageView *sideImg;
@property (nonatomic,strong) UILabel *statusLbl;

@property (nonatomic,strong) UILabel *lineLtwo;
@property (nonatomic,strong) UILabel *lineLone;

@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *introduce;
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UILabel *num;

@property (nonatomic,strong) UILabel *totaltext;
@property (nonatomic,strong) UILabel *totalprice;
@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) UIButton *btnOne;
@property (nonatomic,strong) UIButton *btnTwo;

@property (nonatomic,strong) MASConstraint *lineLtwoTopConstraint;

-(void)showCancelButton:(BOOL)show;

@end
