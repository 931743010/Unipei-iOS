//
//  NSString+GGAddOn.m
//  Gagein
//
//  Created by Dong Yiming on 5/24/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "NSString+GGAddOn.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (GGAddOn)

-(NSString *)stringLimitedToLength:(NSUInteger)aLength
{
    if (self.length < aLength)
    {
        return self;
    }
    
    return [[self substringToIndex:aLength] stringByAppendingString:@"..."];
}

-(NSString *)stringSeperatedWith:(NSString *)aSeporator componentsCount:(NSUInteger)aCompCount maxLength:(NSUInteger)aMaxLength
{
    if (aSeporator.length <= 0 || aCompCount <= 0)
    {
        return nil;
    }
    
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *components = [str componentsSeparatedByString:aSeporator];
    
    if (aCompCount > components.count)
    {
        return self;
    }
    
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < aCompCount; i++)
    {
        if (i)
        {
            [resultStr appendString:@" "];
        }
        
        NSString *comp = components[i];
        if (resultStr.length + comp.length > aMaxLength)
        {
            break;
        }
        
        [resultStr appendString:comp];
    }
    
    return resultStr;
}

-(BOOL)isCaseInsensitiveEqualToString:(NSString *)aString
{
    return [self.lowercaseString isEqualToString:aString.lowercaseString];
}


- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

-(NSString *)trim {
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSString *str = [self stringByTrimmingLeadingCharactersInSet:charSet];
    return [str stringByTrimmingTrailingCharactersInSet:charSet];
}

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

-(NSString *)stringRemoveEndChar:(unichar)aChar {
    
    if (self.length) {
        unichar ch = [self characterAtIndex:self.length - 1];
        if (ch == aChar) {
            return [self substringToIndex:self.length - 1];
        }
    }
    
    return self;
}

- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

-(NSString *)trimEnterCharacter:(NSString *)string{
    NSString *trimString = nil;
    trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    trimString = [trimString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return  trimString;
}

@end
