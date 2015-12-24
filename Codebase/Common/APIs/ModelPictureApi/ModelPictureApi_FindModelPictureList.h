//
//  ModelPictureApi_FindModelPictureList.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface ModelPictureApi_FindModelPictureList : DymRequest
@property (nonatomic, strong) NSNumber      *modelID;
@end


@interface ModelPictureApi_FindModelPictureList_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *modelPictureList;
@end


@interface JPCarModelPicture : DymBaseRespModel
@property (nonatomic, copy) NSString  *originPic;
@end