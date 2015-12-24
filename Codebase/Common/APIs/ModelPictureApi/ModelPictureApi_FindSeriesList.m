//
//  ModelPictureApi_FindSeriesList.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "ModelPictureApi_FindSeriesList.h"

@implementation ModelPictureApi_FindSeriesList

-(NSString *)requestUrl {
    return PATH_modelPictureApi_findSeriesList;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"makesId": [JPUtils stringValueSafe:_makeId]};
}

-(Class)responseModelClass {
    return [ModelPictureApi_FindSeriesList_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end



@implementation ModelPictureApi_FindSeriesList_Result

+(NSDictionary *) jsonMap {
    return @{
             @"seriesList": @"body.SeriesList"
             };
}

+(NSValueTransformer *)seriesListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JPCarSeries class]];
}

@end



@implementation JPCarSeries

// {"seriesid":5001000,"name":"GL8","ename":"","makeid":5000000,"sort":6}
+(NSDictionary *) jsonMap {
    return @{
             @"seriesid": @"seriesid"
             , @"name": @"name"
             , @"ename": @"ename"
             , @"makeid": @"makeid"
             , @"sort": @"sort"
             };
}

- (id)copyWithZone:(nullable NSZone *)zone {
    JPCarSeries *copy = [[JPCarSeries alloc] init];
    copy.seriesid = [self.seriesid copyWithZone:zone];
    copy.name = [self.name copyWithZone:zone];
    copy.ename = [self.ename copyWithZone:zone];
    copy.makeid = [self.makeid copyWithZone:zone];
    copy.sort = [self.sort copyWithZone:zone];
    
    return copy;
}
@end


