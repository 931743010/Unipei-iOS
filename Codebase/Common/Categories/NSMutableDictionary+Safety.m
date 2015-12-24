//
//  NSMutableDictionary+Safety.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "NSMutableDictionary+Safety.h"

@implementation NSMutableDictionary (Safety)
-(void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}
@end
