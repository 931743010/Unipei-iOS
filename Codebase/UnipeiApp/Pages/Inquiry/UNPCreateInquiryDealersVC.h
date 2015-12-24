//
//  UNPCreateInquiryDealersVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"
#import "InquiryApi_InquiryAdd.h"

/// 创建询价单 - 选择经销商
@interface UNPCreateInquiryDealersVC : DymBaseVC

@property (nonatomic, strong) InquiryApi_InquiryAdd     *apiInquiryAdd;

@property (nonatomic, strong) NSArray                   *photos;
@property (nonatomic, strong) NSArray                   *photosRemote;

@property (nonatomic, strong) NSArray                  *localAudios;
@property (nonatomic, strong) NSArray                  *remoteAudios;

@property (nonatomic, copy) NSNumber    *inquiryID;

@property (nonatomic, copy) NSString    *dealerid;

@end
