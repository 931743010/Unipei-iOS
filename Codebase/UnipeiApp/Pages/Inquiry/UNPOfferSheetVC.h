//
//  UNPOfferSheetVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseTableVC.h"

/// 报价单
@interface UNPOfferSheetVC : DymBaseLoadingTableVC

@property (nonatomic, copy) NSNumber    *inquiryID;
@property (nonatomic, copy) NSNumber    *quoid;

@end
