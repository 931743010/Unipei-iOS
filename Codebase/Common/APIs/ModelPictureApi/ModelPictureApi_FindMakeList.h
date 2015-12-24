//
//  ModelPictureApi_FindMakeList.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"



/// 获取汽车制造商列表
@interface ModelPictureApi_FindMakeList : DymRequest

@end




/// 获取汽车制造商列表Result
@interface ModelPictureApi_FindMakeList_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *brandList;
@end


/// 汽车制造商
@interface JPCarMake : DymBaseRespModel
@property (nonatomic, strong) NSNumber  *makeid;
@property (nonatomic, strong) NSNumber  *brandid;
@property (nonatomic, copy) NSString    *firstChar;
@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *pyf;
@property (nonatomic, copy) NSString    *ename;
@property (nonatomic, copy) NSString    *brandlogo;
@property (nonatomic, copy) NSString    *mName;
@property (nonatomic, copy) NSString    *mPyf;
@property (nonatomic, copy) NSString    *mEname;
@property (nonatomic, copy) NSString    *carlogo;
@end

