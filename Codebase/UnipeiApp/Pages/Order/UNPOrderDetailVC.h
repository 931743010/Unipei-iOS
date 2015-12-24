//
//  UNPOrderDetailVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"

@interface UNPOrderDetailVC : DymBaseVC

@property (nonatomic, strong) NSNumber                      *orderID;

/// 需传入NSDictionary对象
-(void)setTheOrder:(id)order;

@end
