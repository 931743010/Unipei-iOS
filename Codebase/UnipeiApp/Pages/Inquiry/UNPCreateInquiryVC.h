//
//  UNPCreateInquiryVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseTableVC.h"
#import "CameraViewController.h"


/// 创建询价单
@interface UNPCreateInquiryVC : DymBaseLoadingTableVC<CameraDelegate>

@property (nonatomic, copy) NSNumber    *inquiryID;
@property (nonatomic, copy) NSString    *vinCode;

- (IBAction)takeVinPhoto:(id)sender;

@end
