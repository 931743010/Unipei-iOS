//
//  CommonApi_FindVersionInfo.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface CommonApi_FindVersionInfo : DymRequest

@property (nonatomic, copy) NSNumber  *osType;
@property (nonatomic, copy) NSString  *apptype;

@end


@interface CommonApi_FindVersionInfo_Result : DymBaseRespModel
@property (nonatomic, copy) NSString    *versoinname;
@property (nonatomic, copy) NSString    *versioncode;
@property (nonatomic, copy) NSString    *download;
@property (nonatomic, copy) NSString    *desc;
@property (nonatomic, copy) NSNumber    *appsize;
@property (nonatomic, copy) NSNumber    *isforce;
@end

/*
 version.setVersoinName(jsonObject.getString("versoinname"));
 version.setVersionCode(jsonObject.getString("versioncode"));
 version.setDownload(jsonObject.getString("download"));
 version.setDescription(jsonObject.getString("description"));
 version.setAppsize(jsonObject.getString("appsize"));
 version.setIsforce(jsonObject.getString("isforce"));
*/