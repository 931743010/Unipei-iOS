//
//  JPQuatationItem.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseRespModel.h"

@interface JPQuatationItem : DymBaseRespModel

@property (nonatomic, copy) NSString    *Name;
@property (nonatomic, copy) NSString    *BrandName;
@property (nonatomic, copy) NSString    *PartsLevel;
@property (nonatomic, copy) NSNumber    *TotalFee;
@property (nonatomic, copy) id          Price;
@property (nonatomic, copy) NSNumber    *RealPrice;

@property (nonatomic, copy) NSString    *Status;
@property (nonatomic, copy) NSNumber    *Num;
@property (nonatomic, copy) NSNumber    *GoodsID;
@property (nonatomic, copy) NSString    *GoodsNO;
@property (nonatomic, copy) NSNumber    *GoodFee;

@property (nonatomic, copy) NSNumber    *QuoID;
@property (nonatomic, copy) NSString    *OENO;
@property (nonatomic, copy) NSNumber    *JpCodei;
@property (nonatomic, copy) id          Version;
@property (nonatomic, copy) NSNumber    *SchID;

@property (nonatomic, assign) NSNumber  *selected;


@end
