//
//  JPQuatationItem.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPQuatationItem.h"

@implementation JPQuatationItem

+(NSDictionary *) jsonMap {
    return @{
             @"PartsLevel": @"PartsLevel"
             , @"Name": @"Name"
             , @"TotalFee": @"TotalFee"
             , @"GoodFee": @"GoodFee"
             , @"Status": @"Status"
             
             , @"Num": @"Num"
             , @"GoodsID": @"GoodsID"
             , @"QuoID": @"QuoID"
             , @"OENO": @"OENO"
             , @"Price": @"Price"
             , @"JpCodei": @"JpCodei"
             
             , @"GoodsNO": @"GoodsNO"
             , @"Version": @"Version"
             , @"RealPrice": @"RealPrice"
             , @"SchID": @"SchID"
             , @"selected": @"IsSelect"
             };
}

@end
