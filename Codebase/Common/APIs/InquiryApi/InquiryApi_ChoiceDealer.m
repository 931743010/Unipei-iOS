//
//  InquiryApi_ChoiceDealer.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/23.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_ChoiceDealer.h"

@implementation InquiryApi_ChoiceDealer

-(NSString *)requestUrl {
    return PATH_inquiryApi_choiceDealer;
}

-(NSDictionary *)paramToPropertyMap {
    NSMutableDictionary *map = @{@"makeID": [JPUtils stringValueSafe:_makeID]}.mutableCopy;
    
    if ([_carID longLongValue] > 0) {
        [map setObject:_carID forKey:@"carID"];
    }
    
    return map;
}

-(Class)responseModelClass {
    return [InquiryApi_ChoiceDealer_Result class];
}

-(NSString *)organIdParamKey {
    return @"organID";
}

//-(BOOL)organIdParamNeeded {
//    return NO;
//}

@end



@implementation InquiryApi_ChoiceDealer_Result

+(NSDictionary *) jsonMap {
    return @{
             @"dealerList": @"body.dealerList"
             };
}
@end
