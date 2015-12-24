//
//  JPAddressNode.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPAddressNode.h"

@implementation JPAddressNode

+(NSDictionary *) jsonMap {
    return @{
             @"addressId": @"id"
             , @"language": @"language"
             , @"parentId": @"parentId"
             , @"path": @"path"
             , @"grade": @"grade"
             , @"name": @"name"
             , @"token": @"token"
             };
}
@end
