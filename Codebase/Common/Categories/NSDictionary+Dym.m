//
//  NSDictionary+Dym.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "NSDictionary+Dym.h"

@implementation NSDictionary (Dym)

-(NSArray *)sortedStringKeys {
    
    NSArray *allKeys = self.allKeys;
    
    return [allKeys sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
}

@end
