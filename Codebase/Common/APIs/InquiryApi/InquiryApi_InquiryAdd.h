//
//  InquiryApi_InquiryAdd.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/23.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_InquiryAdd : DymRequest
//@property (nonatomic, copy) NSNumber    *organid;
@property (nonatomic, copy) NSString    *vin;
@property (nonatomic, copy) NSString    *describe;
@property (nonatomic, copy) NSString    *dealerid;
@property (nonatomic, copy) NSNumber    *make;
@property (nonatomic, copy) NSNumber    *car;
@property (nonatomic, copy) NSNumber    *year;
@property (nonatomic, copy) NSNumber    *model;
@property (nonatomic, copy) NSString    *remark;    // 询价单备注，对应API字段description
@property (nonatomic, copy) NSArray     *categorieList;
@property (nonatomic, copy) NSArray     *picfileList;

@end
