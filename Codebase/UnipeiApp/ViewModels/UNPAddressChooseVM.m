//
//  UNPAddressChooseVM.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPAddressChooseVM.h"
#import "DymRequest+Helper.h"
#import "JPAppStatus.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

//static const DDLogLevel ddLogLevel = DDLogLevelDebug;

@implementation UNPAddressChooseVM

- (id)copyWithZone:(NSZone *)zone {
    
    UNPAddressChooseVM *copy = [[[self class] allocWithZone:zone] init];
    copy.provinceVM = [self.provinceVM copyWithZone:zone];
    copy.cityVM = [self.cityVM copyWithZone:zone];
    copy.districtVM = [self.districtVM copyWithZone:zone];
    
    copy.state = [self.state copyWithZone:zone];
    copy.city = [self.city copyWithZone:zone];
    copy.district = [self.district copyWithZone:zone];
    
    return copy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _provinceVM = [UNPItemsChooseViewModel new];
        _provinceVM.title = @"选择省份";
        
        _cityVM = [UNPItemsChooseViewModel new];
        _cityVM.title = @"选择城市";
        
        _districtVM = [UNPItemsChooseViewModel new];
        _districtVM.title = @"选择区域";
    }
    
    return self;
}

-(NSString *)fullAddress {
    
    NSMutableString *fullAddressString = [NSMutableString new];
    
    id item = _provinceVM.selectedItem;
    if (item && item[@"name"]) {
        [fullAddressString appendString:item[@"name"]];
        
        id item = _cityVM.selectedItem;
        if (item && item[@"name"]) {
            [fullAddressString appendString:item[@"name"]];
            
            id item = _districtVM.selectedItem;
            if (item && item[@"name"]) {
                [fullAddressString appendString:item[@"name"]];
            }
        }
    }
    
    return fullAddressString;
}

-(void)getProvinces:(void(^)(InquiryApi_FindState_Result *result))completion queue:(NSMutableArray *)queue {
    [[DymRequest commonApiSignalWithClass:[InquiryApi_FindState class] queue:queue params:nil] subscribeNext:^(InquiryApi_FindState_Result *result) {
        
        if ([result isKindOfClass:[InquiryApi_FindState_Result class]]) {
            _provinceVM.items = result.list;
            
            /// 根据传入的值选择
            if (_state && _provinceVM.items) {
                for (id province in _provinceVM.items) {
                    if ([province[@"id"] longLongValue] == [_state longLongValue]) {
                        [_provinceVM selectItem:province];
                        break;
                    }
                }
                
                _state = nil;
            }
        }
        
        if (completion) {
            completion(result);
        }
    }];
}

-(void)getCities:(void(^)(InquiryApi_FindCity_Result *result))completion queue:(NSMutableArray *)queue {
    
    id parentID = [_provinceVM.selectedItem objectForKey:@"id"];
    
    [[DymRequest commonApiSignalWithClass:[InquiryApi_FindCity class] queue:queue params:@{@"parentID" : [JPUtils numberValueSafe:parentID]}] subscribeNext:^(InquiryApi_FindCity_Result *result) {
        if ([result isKindOfClass:[InquiryApi_FindCity_Result class]]) {
            _cityVM.items = result.list;
            
            /// 根据传入的值选择
            if (_city && _cityVM.items) {
                for (id city in _cityVM.items) {
                    if ([city[@"id"] longLongValue] == [_city longLongValue]) {
                        [_cityVM selectItem:city];
                        break;
                    }
                }
                
                _city = nil;
            }
        }
        
        if (completion) {
            completion(result);
        }
    }];
}

-(void)getDistricts:(void(^)(InquiryApi_FindDistrict_Result *result))completion queue:(NSMutableArray *)queue {
    
    id parentID = [_cityVM.selectedItem objectForKey:@"id"];
    
    [[DymRequest commonApiSignalWithClass:[InquiryApi_FindDistrict class] queue:queue params:@{@"parentID" : [JPUtils numberValueSafe:parentID]}] subscribeNext:^(InquiryApi_FindDistrict_Result *result) {
        if ([result isKindOfClass:[InquiryApi_FindDistrict_Result class]]) {
            _districtVM.items = result.list;
            
            /// 根据传入的值选择
            if (_district && _districtVM.items) {
                for (id district in _districtVM.items) {
                    if ([district[@"id"] longLongValue] == [_district longLongValue]) {
                        [_districtVM selectItem:district];
                        break;
                    }
                }
                
                _district = nil;
            }
        }
        
        if (completion) {
            completion(result);
        }
    }];
}

@end
