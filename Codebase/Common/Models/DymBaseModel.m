//
//  DymBaseModel.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/1.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseModel.h"

@implementation DymBaseModel


+(NSDictionary *) JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *finalMap = [self baseJSONKeyPathsByPropertyKey].mutableCopy;
    NSDictionary *jsonMap = [self jsonMap];
    if (jsonMap) {
        [finalMap setValuesForKeysWithDictionary:jsonMap];
    }
    
    return finalMap;
}


+(NSDictionary *) jsonMap {
    
    return @{};
    
}

+(NSDictionary *) baseJSONKeyPathsByPropertyKey {
    
    return @{};
    
}


-(void)setNilValueForKey:(NSString *)key {
    [self setValue:@0 forKey:key];
}

@end
