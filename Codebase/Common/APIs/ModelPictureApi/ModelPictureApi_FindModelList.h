//
//  ModelPictureApi_FindModelList.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface ModelPictureApi_FindModelList : DymRequest
@property (nonatomic, strong) NSNumber      *seriesID;
@property (nonatomic, strong) NSNumber      *year;
@end


@interface ModelPictureApi_FindModelList_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *modelList;
@end


@interface JPCarModel : DymBaseRespModel <NSCopying>
@property (nonatomic, strong) NSNumber  *modelid;
@property (nonatomic, copy) NSString  *name;
@property (nonatomic, copy) NSString  *ename;
@property (nonatomic, copy) NSNumber  *year;
@property (nonatomic, copy) NSString  *modelCode;
@property (nonatomic, copy) NSNumber  *makeid;
@property (nonatomic, copy) NSNumber  *seriesid;
@property (nonatomic, copy) id        vehicleid;
@end
