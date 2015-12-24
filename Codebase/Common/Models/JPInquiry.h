//
//  JPInquiry.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseModel.h"

/// 询价单Model
@interface JPInquiry : DymBaseModel

@property (nonatomic, copy) NSString    *token;
@property (nonatomic, copy) NSNumber    *organid;
@property (nonatomic, copy) NSString    *vin;
@property (nonatomic, copy) NSString    *describe;
@property (nonatomic, copy) NSString    *dealerid;
@property (nonatomic, copy) NSNumber    *make;
@property (nonatomic, copy) NSString    *type;
@property (nonatomic, copy) NSNumber    *car;
@property (nonatomic, copy) id          year;
@property (nonatomic, copy) NSNumber    *model;
@property (nonatomic, copy) NSString    *desc;
@property (nonatomic, copy) NSNumber    *inquiryid;
@property (nonatomic, copy) NSNumber    *status;
@property (nonatomic, copy) NSNumber    *createtime;
@property (nonatomic, copy) NSString    *ordersn;
@property (nonatomic, copy) NSString    *inquirysn;
@property (nonatomic, copy) NSString    *startSearchTime;
@property (nonatomic, copy) NSString    *endSearchTime;
@property (nonatomic, copy) NSString    *makeName;
@property (nonatomic, copy) NSString    *carName;
@property (nonatomic, copy) NSString    *modelName;
@property (nonatomic, copy) NSString    *dealerOrganName;
@property (nonatomic, copy) NSString    *dealerPhone;
@property (nonatomic, copy) NSString    *searchStatus;
@property (nonatomic, copy) NSArray     *categorieList;
@property (nonatomic, copy) NSArray     *picfilepList;
@property (nonatomic, copy) NSArray     *picfilevList;
@property (nonatomic, copy) NSString    *pageIndex;
@property (nonatomic, copy) NSString    *pageSize;

-(NSString *)fullModelString;

@end
