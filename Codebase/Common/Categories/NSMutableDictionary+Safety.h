//
//  NSMutableDictionary+Safety.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Safety)

-(void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey;

@end
