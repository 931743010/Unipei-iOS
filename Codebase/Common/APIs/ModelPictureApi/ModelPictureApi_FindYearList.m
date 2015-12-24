//
//  ModelPictureApi_FindYearList.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "ModelPictureApi_FindYearList.h"

@implementation ModelPictureApi_FindYearList

-(NSString *)requestUrl {
    return PATH_modelPictureApi_findYearList;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"seriesId": [JPUtils stringValueSafe:_seriesID]};
}

-(Class)responseModelClass {
    return [ModelPictureApi_FindYearList_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end


@implementation ModelPictureApi_FindYearList_Result

+(NSDictionary *) jsonMap {
    return @{
             @"yearList": @"body.yearList"
             };
}

//+(NSValueTransformer *)yearListJSONTransformer {
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[JPCarYear class]];
//}

@end


//@implementation JPCarYear
//+(NSDictionary *) JSONKeyPathsByPropertyKey {
//    
//    return [self appendJSONKeyPaths:@{
//                                      @"year": @"year"
//                                      }];
//    
//}
//@end
