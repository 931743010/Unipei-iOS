//
//  UserApi_RegistXLCXX.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface UserApi_RegistXLCXX : DymRequest

/** 机构名称 **/
@property (nonatomic, copy) NSString *organName;
/** 联系人 **/
@property (nonatomic, copy) NSString *bossName;
/** 门店照片 **/
@property (nonatomic, copy) NSString *shopPhoto;
/** 门店照片 **/
@property (nonatomic, copy) NSString *mdPhoto;
/** 名片照片 **/
@property (nonatomic, copy) NSString *cardPhoto;
/** 营业执照 **/
@property (nonatomic, copy) NSString *bLPhoto;
/** 经度 **/
@property (nonatomic, copy) NSString *longitude;
/** 纬度 **/
@property (nonatomic, copy) NSString *latitude;
/** 省的code **/
@property (nonatomic, copy) NSNumber *province;
/** 市的code **/
@property (nonatomic, copy) NSNumber *city;
/** 区的code **/
@property (nonatomic, copy) NSNumber *area;
/** 地址 **/
@property (nonatomic, copy) NSString *address;
/** 省名称 **/
@property (nonatomic, copy) NSString *provinceName;
/** 市名称 **/
@property (nonatomic, copy) NSString *cityName;
/** 区名称 **/
@property (nonatomic, copy) NSString *areaName;
/** 营业范围 **/
@property (nonatomic, copy) NSString *scope;
/** 用户ID **/
@property (nonatomic, copy) NSString *userID;
/** 用户头像 **/
@property (nonatomic, copy) NSString *logo;

@end

