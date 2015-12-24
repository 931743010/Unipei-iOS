//
//  ModelPictureApi_FindModelPictureList.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "ModelPictureApi_FindModelPictureList.h"

@implementation ModelPictureApi_FindModelPictureList
-(NSString *)requestUrl {
    return PATH_modelPictureApi_findModelPictureList;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"modelID": _modelID ? : @0};
}

-(Class)responseModelClass {
    return [ModelPictureApi_FindModelPictureList_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}
@end



@implementation ModelPictureApi_FindModelPictureList_Result

+(NSDictionary *) jsonMap {
    return @{
             @"modelPictureList": @"body.modelPictureList"
             };
}

+(NSValueTransformer *)modelPictureListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JPCarModelPicture class]];
}
@end


@implementation JPCarModelPicture

+(NSDictionary *) jsonMap {
    return @{
             @"originPic": @"originPic"
             };
}
@end
