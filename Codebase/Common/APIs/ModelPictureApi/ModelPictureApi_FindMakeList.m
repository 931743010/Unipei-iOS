//
//  ModelPictureApi_FindMakeList.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "ModelPictureApi_FindMakeList.h"

@implementation ModelPictureApi_FindMakeList

-(NSString *)requestUrl {
    return PATH_modelPictureApi_findMakeList;
}


-(Class)responseModelClass {
    return [ModelPictureApi_FindMakeList_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end


/////////////////
@implementation ModelPictureApi_FindMakeList_Result

+(NSDictionary *) jsonMap {
    return @{
             @"brandList": @"body.brandList"
             };
}


+(NSValueTransformer *)brandListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JPCarMake class]];
}

@end



/////////////////////
@implementation JPCarMake

+(NSDictionary *) jsonMap {
    return @{
             @"firstChar": @"firstChar"
             , @"brandid": @"brandid"
             , @"name": @"name"
             , @"pyf": @"pyf"
             , @"ename": @"ename"
             , @"brandlogo": @"brandlogo"
             , @"makeid": @"makeid"
             , @"mName": @"mName"
             , @"mPyf": @"mPyf"
             , @"mEname": @"mEname"
             , @"carlogo": @"carlogo"
             };
}

@end


// {"firstChar":"A","brandid":17,"name":"奥迪","pyf":"AD","ename":"AUDI","brandlogo":"logo/carlogo/audi.png","makeid":35000000,"mName":"一汽奥迪","mPyf":"YQAD","mEname":"FAW AUDI","carlogo":"logo/carlogo/2015020101456147306.png"}
