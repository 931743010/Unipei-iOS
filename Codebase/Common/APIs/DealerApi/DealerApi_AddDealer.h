//
//  DealerApi_AddDealer.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/11.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface DealerApi_AddDealer : DymRequest

@property(nonatomic, copy) NSString *uid;           // == orgId
@property(nonatomic, copy) NSString *info;
@property(nonatomic, copy) NSString *categoryId;    // 多个用逗号隔开
@property(nonatomic, copy) NSString *contact;
@property(nonatomic, copy) NSString *telphone;
@property(nonatomic, copy) NSString *runYears;
@property(nonatomic, copy) NSString *personNum;
@property(nonatomic, copy) NSString *makesId;       // 多个用逗号隔开
@property(nonatomic, copy) NSString *introduction;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *mdPhoto;       // 多个用逗号隔开
@property(nonatomic, copy) NSString *concept;
@property(nonatomic, copy) NSString *advent;

@end




@interface DealerApi_AddDealer_Result : DymBaseRespModel

@property (nonatomic, copy) NSString    *dealerId;

@end

