//
//  OTSPredicate.m
//  OneStore
//
//  Created by Yim Daniel on 13-1-16.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import "GGPredicate.h"
#import "NSString+GGAddOn.h"

#define PRED_CONDITION_MOBILE           @"[0-9]{8,14}"
#define PRED_CONDITION_MOBILE_ADVANCED  @"^[1][0-9][0-9]{9}$"
#define PRED_CONDITION_NUMERIC          @"[0-9]+"
#define PRED_CONDITION_QQ               @"[1-9][0-9]{4,}"
#define PRED_CONDITION_CHARACTER        @"[A-Z0-9a-z]+"
#define PRED_CONDITION_PASSWORD         @"[^\\n\\s]{6,16}"
#define PRED_CONDITION_SPECIAL_CHAR     @"[A-Z0-9a-z._%+-@]+"
#define PRED_CONDITION_EMAIL            @"^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"
#define PRED_COMDITION_URL              @"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
#define PRED_COMDITION_URL_HTTP         @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
#define PRED_CONDITION_CN_CHAR          @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+"
#define PRED_CONDITION_FAX              @"^([0-9]|-|—|)+$"

@implementation GGPredicate

+(BOOL)checkUserName:(NSString *)aCandidate
{
    return [self checkPhoneNumber:aCandidate] || [self checkEmail:aCandidate];
}

+(BOOL)checkPhoneNumber:(NSString *)aCandidate
{
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_MOBILE_ADVANCED];
}

+(BOOL)checkNumeric:(NSString *)aCandidate
{
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_NUMERIC];
}

+ (BOOL)containsHan:(NSString*)cadidate
{
    NSString* const pattern = @"\\p{script=Han}+";
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                      options:0
                                                                        error:nil];
    NSRange range = NSMakeRange(0, [cadidate length]);
    return [regex numberOfMatchesInString:cadidate
                                  options:0
                                    range:range] > 0;
}

+(BOOL)checkCharacter:(NSString *)aCandidate
{
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_CHARACTER];
}

+(BOOL)containsSpace:(NSString *)string {
    
    NSRange range = [string rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
    
}

+(BOOL)stringIsAllSpace:(NSString *)string{
    //去掉字符串中得空格
    NSString *temp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //看剩下的字符串的长度是否为零
    if ([temp length]==0)//由空格组成
    {
        return YES;
    }
    return NO;
}
+(BOOL)checkFAX:(NSString *)aCandidate{
    
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_FAX];
    
}
+(BOOL)checkQQ:(NSString *)aCandidate{
    
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_QQ];
}
+(BOOL)checkPassword:(NSString *)aCandidate
{
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_PASSWORD];
}

+(BOOL)checkSpecialChar:(NSString *)aCandidate
{
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_SPECIAL_CHAR];
}

+(BOOL)checkEmail:(NSString *)aCandidate
{
    return [self __checkCandidate:aCandidate condition:PRED_CONDITION_EMAIL];
}

+(BOOL)checkURL:(NSString *)aURL
{
    NSString *urlString = aURL.trim.lowercaseString;
    if ([urlString isEqualToString:@"www."]) {
        return NO;
    }
    
    return [self __checkCandidate:aURL condition:PRED_COMDITION_URL] || [self __checkCandidate:aURL condition:PRED_COMDITION_URL_HTTP];
}


+ (BOOL)__checkCandidate: (NSString *) aCandidate condition: (NSString*) aCondition
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", aCondition];
    return [predicate evaluateWithObject:aCandidate];
}
@end
