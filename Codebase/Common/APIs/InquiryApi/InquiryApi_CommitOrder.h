//
//  InquiryApi_CommitOrder.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_CommitOrder : DymRequest

/// 接受(YES)还是拒绝(NO)
@property (nonatomic, assign) BOOL      status;
@property (nonatomic, copy) NSNumber    *addressID;
@property (nonatomic, copy) NSNumber    *schid;
@property (nonatomic, copy) NSNumber    *inquiryid;
@property (nonatomic, copy) NSNumber    *quoid;
@property (nonatomic, copy) NSArray     *goodsinfo;
@property (nonatomic, copy) NSString    *couponsn;
//@property (nonatomic, copy) NSNumber    *MakeID;
//@property (nonatomic, copy) NSNumber    *CarID;
//@property (nonatomic, copy) NSString    *Year;
//@property (nonatomic, copy) NSNumber    *ModelID;

/// 物流公司名称 手写
@property (nonatomic, copy) NSString    *shiplogis;
/// 物流公司名称 下拉
@property (nonatomic, copy) NSString    *shipname;

@end
