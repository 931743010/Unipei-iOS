//
//  UNPAddressChooseVM.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNPItemsChooseViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/Mantle.h>

#import "InquiryApi_FindDistrict.h"
#import "InquiryApi_FindCity.h"
#import "InquiryApi_FindState.h"

static NSString *NOTIFY_String_addressSelected = @"NOTIFY_String_addressSelected";

@interface UNPAddressChooseVM : NSObject

/// 省
@property (nonatomic, strong) UNPItemsChooseViewModel   *provinceVM;
/// 市
@property (nonatomic, strong) UNPItemsChooseViewModel   *cityVM;
/// 区
@property (nonatomic, strong) UNPItemsChooseViewModel   *districtVM;

@property (nonatomic, copy) NSNumber                    *state;
@property (nonatomic, copy) NSNumber                    *city;
@property (nonatomic, copy) NSNumber                    *district;

-(NSString *)fullAddress;

-(void)getProvinces:(void(^)(InquiryApi_FindState_Result *result))completion queue:(NSMutableArray *)queue;

-(void)getCities:(void(^)(InquiryApi_FindCity_Result *result))completion queue:(NSMutableArray *)queue;

-(void)getDistricts:(void(^)(InquiryApi_FindDistrict_Result *result))completion queue:(NSMutableArray *)queue;

@end
