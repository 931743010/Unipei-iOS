//
//  DymRequest.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "GTMBase64.h"
#import "JPAppStatus.h"
#import <UIDeviceUtil/UIDeviceUtil.h>

static const DDLogLevel ddLogLevel = DDLogLevelDebug;

static NSString * const DEFAULT_API_VERSION = @"V2.1";

#define kChosenDigestLength     CC_SHA1_DIGEST_LENGTH
#define DESKEY @"jiapartsjiapartsjiaparts"

@implementation DymRequest

// 默认请求超市时间为30秒
- (NSTimeInterval)requestTimeoutInterval {
    return 30;
}

-(Class)responseModelClass {
    return [DymBaseRespModel class];
}

-(NSDictionary *)requestHeaderFieldValueDictionary {
    NSString *apiVersion = [self apiVersionString];
    apiVersion = apiVersion ? : DEFAULT_API_VERSION;
    return @{@"version":apiVersion};
}

-(NSString *)apiVersionString {
    return DEFAULT_API_VERSION;
}

- (id)responseModel {
    
    id json = self.cacheJson ? : self.responseJSONObject;
    NSError *error;
    
    return [MTLJSONAdapter modelOfClass:[self responseModelClass] fromJSONDictionary:json error:&error];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

#pragma mark -
// 遍历传入的dictionary，使用Key-value coding，批量动态设置参数值
- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        if (params != nil) {
            [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([key isKindOfClass:[NSString class]] && [self respondsToSelector:NSSelectorFromString(key)]) {
                    [self setValue:obj forKey:key];
                }
            }];
        }
    }
    return self;
}

-(NSDictionary *)paramToPropertyMap {
    return @{};
}

//手机品牌|手机型号|操作系统类型|设备唯一标示|系统版本号| app版本号| app类型|用户ID|
//1.	操作系统类型(1安卓，2 IOS).
//2.	未登陆 用户ID为0
//appType  unpeiAPP:1
// e.g.  Lenovo|Lenovo K30-T|1|867527024085486|Android4.4.4|当前版本：2.0.0|1|215
//       Apple|iPhone 5C|2|A5B2B9F4-DC84-482F-907B-869AF0B6CB5B|Version 8.4 (Build 12H143)|2.0.0|0
-(NSString *)requestHeader {
    NSString *vender = @"Apple";
    NSString *model = [UIDeviceUtil hardwareSimpleDescription];
    NSString *osType = @"2";
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *systemVersion = [[NSProcessInfo processInfo] operatingSystemVersionString];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *appType = @"1";
    NSString *userID = [JPUtils stringValueSafe:[JPAppStatus loginInfo].organID defaultValue:@"0"];
    
//    return @"Lenovo|Lenovo K30-T|1|867527024085486|Android4.4.4|当前版本：2.0.0|1|215";
    return [@[vender, model, osType, deviceID, systemVersion, appVersion, appType, userID] componentsJoinedByString:@"|"];
}

/// 每个请求都需传递的通用参数在此添加
-(NSMutableDictionary *)commonParams {
    
    NSMutableDictionary *commonParams = [NSMutableDictionary dictionary];
    
    [commonParams setObjectSafe:[self requestHeader] forKey:@"header"];
    
    if ([JPAppStatus isLoggedIn]) {
        [commonParams setObjectSafe:[JPAppStatus loginInfo].token forKey:@"token"];
        
        if ([self organIdParamNeeded]) {
            id organID = [JPAppStatus loginInfo].organID;
            if ([self organIdParamClass] == [NSString class]) {
                organID = [JPUtils stringValueSafe:organID];
            }
            if (organID) {
                [commonParams setValuesForKeysWithDictionary:@{[self organIdParamKey]: organID}];
            }
        }
    }
    
    return commonParams;
}

-(NSString *)organIdParamKey {
    return @"organid";
}

-(Class)organIdParamClass {
    return [NSNumber class];
}

-(BOOL)organIdParamNeeded {
    return YES;
}

-(id)requestArgument {
    NSMutableDictionary *commonParams = [self commonParams];
    NSDictionary *specParams = [self paramToPropertyMap];
    if (specParams) {
        [commonParams setValuesForKeysWithDictionary:specParams];
        //setValuesForKeysWithDictionary addEntriesFromDictionary
    }
    
    NSString *value = [self jsonFromData:commonParams];
    return @{@"param": value};
}

#pragma mark -
-(NSString *)encryptUsing3DES:(NSString *)str {
    return [self _tripleDES:str encryptOrDecrypt:kCCEncrypt];
}

-(NSString*)_tripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *)[DESKEY UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

-(NSString*)jsonFromData:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 //NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        DDLogDebug(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

@end
