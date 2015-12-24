//
//  JPInquiryAddress.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/12.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseRespModel.h"

@interface JPInquiryAddress : DymBaseRespModel

@property (nonatomic, copy) id    addressID;
@property (nonatomic, copy) id    organid;
@property (nonatomic, copy) id    contactname;

@property (nonatomic, copy) id    state;
@property (nonatomic, copy) id    city;
@property (nonatomic, copy) id    district;

@property (nonatomic, copy) id    statename;
@property (nonatomic, copy) id    cityname;
@property (nonatomic, copy) id    districtname;

@property (nonatomic, copy) id    zipcode;
@property (nonatomic, copy) id    address;
@property (nonatomic, copy) id    phone;
@property (nonatomic, copy) id    memo;
@property (nonatomic, copy) id    isdefault;
@property (nonatomic, copy) id    createtime;
@property (nonatomic, copy) id    updatetime;

@end


