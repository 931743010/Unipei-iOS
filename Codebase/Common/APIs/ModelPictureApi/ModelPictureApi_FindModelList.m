//
//  ModelPictureApi_FindModelList.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "ModelPictureApi_FindModelList.h"
#import "JPUtils.h"

@implementation ModelPictureApi_FindModelList

-(NSString *)requestUrl {
    return PATH_modelPictureApi_findModelList;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"seriesId": [JPUtils stringValueSafe:_seriesID]
             , @"year" : [JPUtils stringValueSafe:_year]};
}

-(Class)responseModelClass {
    return [ModelPictureApi_FindModelList_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}
@end



@implementation ModelPictureApi_FindModelList_Result

+(NSDictionary *) jsonMap {
    return @{
             @"modelList": @"body.modelList"
             };
}


+(NSValueTransformer *)modelListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JPCarModel class]];
}
@end


@implementation JPCarModel

+(NSDictionary *) jsonMap {
    return @{
             @"modelid": @"modelid"
             , @"name": @"name"
             , @"ename": @"ename"
             , @"year": @"year"
             , @"modelCode": @"code"
             , @"makeid": @"makeid"
             , @"seriesid": @"seriesid"
             , @"vehicleid": @"vehicleid"
             };
}

- (id)copyWithZone:(nullable NSZone *)zone {
    JPCarModel *copy = [[JPCarModel alloc] init];
    
    copy.modelid = [self.modelid copyWithZone:zone];
    copy.name = [self.name copyWithZone:zone];
    copy.ename = [self.ename copyWithZone:zone];
    copy.year = [self.year copyWithZone:zone];
    copy.modelCode = [self.modelCode copyWithZone:zone];
    copy.makeid = [self.makeid copyWithZone:zone];
    copy.seriesid = [self.seriesid copyWithZone:zone];
    
    if ([self.vehicleid conformsToProtocol:@protocol(NSCopying)]) {
        copy.vehicleid = [self.vehicleid copyWithZone:zone];
    }
    
    return copy;
}

@end


/*
 {
 "modelid": 1001003,
 "name": "1.3L手动豪华型",
 "ename": "",
 "year": 2008,
 "code": "QRQC-A1-3",
 "makeid": 1000000,
 "seriesid": 1001000,
 "vehicleid": 0,
 }
 */

