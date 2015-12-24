//
//  ModelPictureApi_FindYearList.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface ModelPictureApi_FindYearList : DymRequest
@property (nonatomic, strong) NSNumber      *seriesID;
@end

@interface ModelPictureApi_FindYearList_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *yearList;
@end


//@interface JPCarYear : DymBaseRespModel
//@property (nonatomic, strong) NSNumber  *year;
//@end