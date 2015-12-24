//
//  DymRequest.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTKNetwork/YTKRequest.h>
#import "JPServerApiURL.h"
#import "DymBaseRespModel.h"
#import "YTKBaseRequest+Dym.h"
#import "NSMutableDictionary+Safety.h"
#import "JPUtils.h"

typedef NS_ENUM(NSInteger, EJPTimeSeconds) {
    kJPTimeSecondsHour = 3600
    , kJPTimeSecondsDay = 86400
    , kJPTimeSecondsWeek = 604800
};

/// Request对象的基类, 默认以Post方式请求
@interface DymRequest : YTKRequest

//@property (nonatomic, copy) NSString    *token;


/// 将对象转换为Json String
-(NSString*)jsonFromData:(id)object;

/// 对String进行3DES加密
-(NSString *)encryptUsing3DES:(NSString *)str;

/// 参数-属性 Map, 子类根据自身参数Override
-(NSDictionary *)paramToPropertyMap;

/// 传入参数Dictionary初始化，keys和values要和paramToPropertyMap的定义一致
- (instancetype)initWithParams:(NSDictionary *)params;

/// 子类重写此方法，设置自己的response mode 类型
-(Class)responseModelClass;

/// response model对象
- (id)responseModel;

/// 为了应对接口自由不羁的大小写，如果key != organid，请重写此方法，返回正确的key
-(NSString *)organIdParamKey;

/// organId参数类型，默认为NSNumber，可重写
-(Class)organIdParamClass;

/// 如果不需要传organId参数，可重写此方法返回NO,默认YES
-(BOOL)organIdParamNeeded;

/// API版本号，可重写
-(NSString *)apiVersionString;
@end
