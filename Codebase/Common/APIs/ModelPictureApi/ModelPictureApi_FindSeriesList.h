//
//  ModelPictureApi_FindSeriesList.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

/// 根据MAKE查找车系
@interface ModelPictureApi_FindSeriesList : DymRequest
@property (nonatomic, strong) NSNumber      *makeId;
@end


/// 根据MAKE查找车系结果
@interface ModelPictureApi_FindSeriesList_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *seriesList;
@end

/// 车型系列
@interface JPCarSeries : DymBaseRespModel <NSCopying>
@property (nonatomic, strong) NSNumber  *seriesid;
@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *ename;
@property (nonatomic, copy) NSNumber    *makeid;
@property (nonatomic, copy) id          sort;
@end

