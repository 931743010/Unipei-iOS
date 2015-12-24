//
//  UNPOfferItemsVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"

/// 报价商品
@interface UNPOfferItemsVC : DymBaseVC

@property (nonatomic, copy) NSNumber    *inquiryID;
@property (nonatomic, copy) NSNumber    *quoid;

@property (nonatomic, copy) dispatch_block_t    schemeRefusedBlock;

@end
