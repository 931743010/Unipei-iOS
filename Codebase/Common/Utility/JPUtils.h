//
//  JPUtils.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/8.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPNotificationStrings.h"

/**
 * 订单状态（待付款、待发货
 * 、待收货、已收货、
 * 已取消、待同意退货、
 * 退货待发货、退货待收货、
 * 退货完成--1/2/3/9/10/11/12/13/14）
 */
typedef NS_ENUM(NSInteger, EJPOrderStatus) {
    kJPOrderStatusAll                       = 0     // 全部, server不会返回此值，仅供filter使用
    , kJPOrderStatusWaitingForPayment       = 1     // 待付款
    , kJPOrderStatusWaitingForShipping      = 2     // 待发货
    , kJPOrderStatusWaitingForReceival      = 3     // 待收货
    , kJPOrderStatusRefused                 = 5     // 已拒收, server不会返回此值，仅供filter使用
    , kJPOrderStatusReceived                = 9     // 已收货
    , kJPOrderStatusCancelled               = 10    // 已取消
    , kJPOrderStatusReturnPending           = 11    // 待同意退货
    , kJPOrderStatusReturnWaitForShipping   = 12    // 退货待发货
    , kJPOrderStatusReturnWaitForReceival   = 13    // 退货待收货
    , kJPOrderStatusReturnOK                = 14    // 退货完成
};

@interface JPUtils : NSObject

+(UIWindow *)godModeWindow;

+(UIWindow *)defaultWindow;

/// 开启上帝视角，显示View于默认window之上
+(void)openGodModeWithView:(UIView *)view;

+(void)openGodModeWithVC:(UIViewController *)vc;

/// 关闭上帝视角
+(void)closeGodMode;

/// 生产随机数字串, 基于系统时间+随机数
+(NSString *)randomDigitString;

+(UIView *)installBottomLine:(UIView *)view color:(UIColor *)color insets:(UIEdgeInsets)insets;

+(UIView *)installTopLine:(UIView *)view color:(UIColor *)color insets:(UIEdgeInsets)insets;

+(UIView *)installRightLine:(UIView *)view color:(UIColor *)color insets:(UIEdgeInsets)insets;

+(UIView *)installRightLine:(UIView *)view extendToSuperview:(BOOL)extendToSuperview color:(UIColor *)color insets:(UIEdgeInsets)insets;

+(UIViewController *)topMostVC;


+(NSString *)fullApiPath:(NSString *)relativePath;
+(NSString *)fullMediaPath:(NSString *)relativePath;

/// yyyy-MM-dd hh:mm
+(NSString *)timeStringFromStamp:(CGFloat)timeStamp;
/// yyyy-MM-dd
+(NSString *)dateStringFromStamp:(CGFloat)timeStamp;

+(BOOL)isNotNull:(id)object;

+(NSString *)stringValueSafe:(id)item defaultValue:(NSString *)defaultValue;
+(NSString *)stringValueSafe:(id)item;
+(NSNumber *)numberValueSafe:(id)item;
+(NSString *)stringReplaceNil:(NSString *)item defaultValue:(NSString *)defaultValue;


#pragma mark - alert
+(void)showAlert:(NSString *)title message:(NSString *)message;
+(void)showAlert:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confrimTitle;

+(UIAlertController *)alert:(NSString *)title message:(NSString *)message
               comfirmBlock:(void (^)(UIAlertAction *action))comfirmBlock
                cancelBlock:(void (^)(UIAlertAction *action))cancelBlock;

+(UIAlertController *)alert:(NSString *)title message:(NSString *)message
               comfirmBlock:(void (^)(UIAlertAction *action))comfirmBlock
               confirmTitle:(NSString *)confirmTitle
                cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
                cancelTitle:(NSString *)cancelTitle;

+(NSDate *)beginningOfDate:(NSDate *)date;
+(NSDate *)endingOfDate:(NSDate *)date;

+(NSString *)nameOfOrderStatus:(NSInteger)orderStatus;

+(void)doAsync:(dispatch_block_t)block completion:(dispatch_block_t)completionBlock;

#pragma mark - 缓存
+(CGFloat)cacheSizeInMega;

+(void)clearCache;

#pragma mark - order
+(BOOL)canCancelOrder:(id)order;
+(BOOL)canConfirmOrder:(id)order;

/// 此方法专治各种接口各种不服，疗效显著
+(id)valueFromObject:(id)object possibleKeys:(NSArray *)possibleKeys;
/// 此方法专治各种接口各种不服，疗效显著
+(void)setValue:(id)value object:(id)object possibleKeys:(NSArray *)possibleKeys;

/// vin码格式化
+(NSString *)vinFormatedString:(NSString *)string;

+(void)restrictTextField:(id<UITextInput>)textInput maxLength:(NSUInteger)maxLength;

+(NSMutableArray *)allCharsInString:(NSString *)string;

+(BOOL)checkHanCharacters:(NSString *)string;

+(BOOL)checkNoEmojiCharacters:(NSString *)string;

+(UIFont *)boldFont:(UIFont *)font;

+(BOOL)isContainsEmoji:(NSString *)string;


+(void)routeToPath:(NSString *)path paramString:(NSString *)paramString;

+(NSString *)stringByConvertReturnTagFromHTMLString:(NSString *)htmlString;

@end

#define SECONDS_ALMOST_A_DAY    (3600 * 24 - 10)
