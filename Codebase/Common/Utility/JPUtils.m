//
//  JPUtils.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/8.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPUtils.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DymBaseAppDelegate.h"
#import "JPServerApiURL.h"
#import <SDWebImage/SDImageCache.h>
#import "AudioAmrUtil.h"
#import "GGPredicate.h"
#import "JPGuessMyKey.h"
#import "JPGuessMyKey.h"

@implementation JPUtils

+(UIWindow *)godModeWindow {
    return ((DymBaseAppDelegate *)[UIApplication sharedApplication].delegate).godModeWindow;
}

+(UIWindow *)defaultWindow {
    return ((DymBaseAppDelegate *)[UIApplication sharedApplication].delegate).window;
}

+(void)openGodModeWithView:(UIView *)view {
    if ([view isKindOfClass:[UIView class]]) {
        UIWindow *extWin = [self godModeWindow];
        view.frame = extWin.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [extWin addSubview:view];
        
        [extWin makeKeyAndVisible];
    }
}

+(void)openGodModeWithVC:(UIViewController *)vc {
    
    UIWindow *extWin = [self godModeWindow];
    extWin.hidden = NO;
    extWin.rootViewController = vc;
    
    [extWin makeKeyAndVisible];
}

+(void)closeGodMode {
    [self godModeWindow].rootViewController = nil;
    [[self godModeWindow].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self defaultWindow] makeKeyAndVisible];
    [self godModeWindow].hidden = YES;
}

+(NSString *)randomDigitString {
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSInteger randomNumber = arc4random() % 10000;
    return [NSString stringWithFormat:@"%ld%@", (long)interval, @(randomNumber)];
}

+(UIView *)installBottomLine:(UIView *)view color:(UIColor *)color insets:(UIEdgeInsets)insets {
    UIView *line = [UIView new];
    line.backgroundColor = color;
    
    UIView *superView = view.superview ? view.superview : view;
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(superView.mas_leading).offset(insets.left);
        make.trailing.equalTo(superView.mas_trailing).offset(-insets.right);
        make.bottom.equalTo(view.mas_bottom).offset(-insets.bottom);
        make.height.equalTo(@0.5);
    }];
    
    return line;
}

+(UIView *)installTopLine:(UIView *)view color:(UIColor *)color insets:(UIEdgeInsets)insets {
    UIView *line = [UIView new];
    line.backgroundColor = color;
    
    UIView *superView = view.superview ? view.superview : view;
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(superView.mas_leading).offset(insets.left);
        make.trailing.equalTo(superView.mas_trailing).offset(-insets.right);
        make.top.equalTo(view.mas_top).offset(insets.top);
        make.height.equalTo(@0.5);
    }];
    
    return line;
}

+(UIView *)installRightLine:(UIView *)view color:(UIColor *)color insets:(UIEdgeInsets)insets {
    return [self installRightLine:view extendToSuperview:NO color:color insets:insets];
}

+(UIView *)installRightLine:(UIView *)view extendToSuperview:(BOOL)extendToSuperview color:(UIColor *)color insets:(UIEdgeInsets)insets {
    UIView *line = [UIView new];
    line.backgroundColor = color;
    
    UIView *superView = view;
    if (extendToSuperview) {
        superView = view.superview ? view.superview : view;
    }
    
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(superView).insets(insets);
        make.trailing.equalTo(view.mas_trailing).offset(-insets.left);
        make.width.equalTo(@0.5);
    }];
    
    return line;
}

+(UIViewController *)topMostVC {
    
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

+(NSString *)fullApiPath:(NSString *)relativePath {
    return [[JPServerApiURL baseURL] stringByAppendingPathComponent:relativePath];
}

+(NSString *)fullMediaPath:(NSString *)relativePath {
    return [[JPServerApiURL fileServerURL] stringByAppendingPathComponent:relativePath];
}

+(NSString *)timeStringFromStamp:(CGFloat)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    return [fmt stringFromDate:date];
}

+(NSString *)dateStringFromStamp:(CGFloat)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];

    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyy-MM-dd";
//    fmt.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [fmt stringFromDate:date];
}

+(BOOL)isNotNull:(id)object {
    return object != nil && ![object isKindOfClass:[NSNull class]];
}


+(NSString *)stringValueSafe:(id)item defaultValue:(NSString *)defaultValue {
    if ([item respondsToSelector:@selector(stringValue)]) {
        return [item stringValue];
    } else if ([item isKindOfClass:[NSString class]]) {
        return item;
    }
    
    return defaultValue ? : @"";
}

+(NSString *)stringReplaceNil:(NSString *)item defaultValue:(NSString *)defaultValue{
    if(!item || [item isEqualToString:@""]){
        return defaultValue;
    }else{
        return item;
    }
}


+(NSString *)stringValueSafe:(id)item {
    return [self stringValueSafe:item defaultValue:nil];
}

+(NSNumber *)numberValueSafe:(id)item {
    if ([item respondsToSelector:@selector(doubleValue)]) {
        return @([item doubleValue]);
    } if ([item respondsToSelector:@selector(longLongValue)]) {
        return @([item longLongValue]);
    } else if ([item isKindOfClass:[NSNumber class]]) {
        return item;
    }
    
    return @0;
}


#pragma mark - alert
+(void)showAlert:(NSString *)title message:(NSString *)message {
    [self showAlert:title message:message confirmTitle:@"确定"];
}

+(void)showAlert:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confrimTitle {
    UIAlertController *alertVC = [self alert:title message:message comfirmBlock:nil confirmTitle:confrimTitle cancelBlock:nil cancelTitle:@""];
    [[self topMostVC] presentViewController:alertVC animated:YES completion:nil];
}

+(UIAlertController *)alert:(NSString *)title message:(NSString *)message comfirmBlock:(void (^)(UIAlertAction *action))comfirmBlock cancelBlock:(void (^)(UIAlertAction *action))cancelBlock {
    
    return [self alert:title message:message comfirmBlock:comfirmBlock confirmTitle:@"确定" cancelBlock:cancelBlock cancelTitle:@"取消"];
}

+(UIAlertController *)alert:(NSString *)title message:(NSString *)message
               comfirmBlock:(void (^)(UIAlertAction *action))comfirmBlock
               confirmTitle:(NSString *)confirmTitle
                cancelBlock:(void (^)(UIAlertAction *action))cancelBlock
                cancelTitle:(NSString *)cancelTitle {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:comfirmBlock];
    [alertVC addAction:ok];
    
    if (cancelBlock) {
        UIAlertAction *canel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:cancelBlock];
        [alertVC addAction:canel];
    }
    
    return alertVC;
}

+(NSDate *)beginningOfDate:(NSDate *)date {
    return [[NSCalendar currentCalendar] startOfDayForDate:date];
//    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
//    comp.hour = 0;
//    comp.minute = 0;
//    comp.second = 0;
//    
//    return [[NSCalendar currentCalendar] dateFromComponents:comp];
}

+(NSDate *)endingOfDate:(NSDate *)date {
    NSDate *startDate = [[NSCalendar currentCalendar] startOfDayForDate:date];
    NSDate *endDate = [startDate dateByAddingTimeInterval:SECONDS_ALMOST_A_DAY];
    NSLog(@"date:%@\nstartDate:%@\nendDate:%@", date, startDate, endDate);
    return endDate;
}

+(NSDate *)localDateFromGMT:(NSDate *)gmtDate {
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    return [gmtDate dateByAddingTimeInterval:timeZoneSeconds];
}

+(NSDate *)gmtDateFromLocal:(NSDate *)localDate {
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    return [localDate dateByAddingTimeInterval:-timeZoneSeconds];
}


/**
 * 订单状态（待付款、待发货
 * 、待收货、已收货、
 * 已取消、待同意退货、
 * 退货待发货、退货待收货、
 * 退货完成--1/2/3/9/10/11/12/13/14）
 */
+(NSString *)nameOfOrderStatus:(NSInteger)orderStatus {
    switch (orderStatus) {
            
        case kJPOrderStatusAll:
            return @"全部";
            break;
            
        case kJPOrderStatusWaitingForPayment:
            return @"待付款";
            break;
            
        case kJPOrderStatusWaitingForShipping:
            return @"待发货";
            break;
            
        case kJPOrderStatusWaitingForReceival:
            return @"待收货";
            break;
            
        case kJPOrderStatusRefused:
            return @"已拒收";
            break;
            
        case kJPOrderStatusReceived:
            return @"已收货";
            break;
            
        case kJPOrderStatusCancelled:
            return @"已取消";
            break;
            
        case kJPOrderStatusReturnPending:
            return @"待同意退货";
            break;
            
        case kJPOrderStatusReturnWaitForShipping:
            return @"退货待发货";
            break;
            
        case kJPOrderStatusReturnWaitForReceival:
            return @"退货待收货";
            break;
            
        case kJPOrderStatusReturnOK:
            return @"退货完成";
            break;
            
        default:
            break;
    }
    
    return @"未知状态";
}

+(void)doAsync:(dispatch_block_t)block completion:(dispatch_block_t)completionBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if (block) {
            block();
        }
        
        dispatch_async(dispatch_get_main_queue(), completionBlock);
    });
}

#pragma mark - 缓存
+(long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

+(CGFloat)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        
        return folderSize;
    }
    
    return 0;
}

+(CGFloat)cacheSizeInMega {
    NSString *path = [AudioAmrUtil convertDir];
    long long fileSize = [self folderSizeAtPath:path];
    fileSize += [[SDImageCache sharedImageCache] getSize];
    
    return  fileSize / (1024.0 * 1024.0);
}

+(void)clearCache {
    [AudioAmrUtil cleanCache];
    [[SDImageCache sharedImageCache] clearDisk];
}

+(BOOL)canCancelOrder:(id)order {
    
    id statusObject = [self valueFromObject:order possibleKeys:[JPGuessMyKey keys_status]];
    id payment = [self valueFromObject:order possibleKeys:[JPGuessMyKey keys_payment]];
    id payTime = [self valueFromObject:order possibleKeys:[JPGuessMyKey keys_paytime]];
    
    if (statusObject && payment && payTime) {
        
        NSInteger status = [statusObject integerValue];
        
        if (status == kJPOrderStatusWaitingForPayment || status == kJPOrderStatusWaitingForShipping) {
            // payment: 1. 在线支付 2.线下支付
            // paytime: 如果>=0 说明已支付
            if (!([payment integerValue] == 1 && [payTime longLongValue] > 0)) {
                return YES;
            }
        }
    }
    
    return NO;
}

+(BOOL)canConfirmOrder:(id)order {
    
    id statusObject = [self valueFromObject:order possibleKeys:[JPGuessMyKey keys_status]];
    id statusName = [self valueFromObject:order possibleKeys:[JPGuessMyKey keys_statusName]];
    
    if (statusObject && statusName) {
        NSInteger status = [statusObject integerValue];
        if (status == kJPOrderStatusWaitingForReceival && ![statusName isEqualToString:@"已拒收"]) {
            return YES;
        }

    }
    
    return NO;
}

/// 此方法专治各种接口各种不服，疗效显著
+(id)valueFromObject:(id)object possibleKeys:(NSArray *)possibleKeys {
    
    id value = nil;
    
    if (object && possibleKeys.count > 0) {
        for (NSString *key in possibleKeys) {
            if ([key isKindOfClass:[NSString class]]) {
                value = object[key];
                
                if (value) {
                    break;
                }
            }
        }
    }
    
    return value;
}

/// 此方法专治各种接口各种不服，疗效显著
+(void)setValue:(id)value object:(id)object possibleKeys:(NSArray *)possibleKeys {
    if (value && object && possibleKeys.count > 0) {
        for (NSString *key in possibleKeys) {
            if ([key isKindOfClass:[NSString class]] && [object objectForKey:key] != nil) {
                [object setObject:value forKey:key];
                break;
            }
        }
    }
}

+(NSString *)vinFormatedString:(NSString *)string {
    
    if (string.length <= 0) {
        return nil;
    }
    
    string = [[string stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
    
    NSMutableArray  *parts = [NSMutableArray array];
    
    NSRange range = NSMakeRange(0, 0);
    if (string.length > 3) {
        range = NSMakeRange(0, 3);
        [parts addObject:[string substringWithRange:range]];
    }
    
    if (string.length > 6) {
        range = NSMakeRange(3, 3);
        [parts addObject:[string substringWithRange:range]];
    }
    
    if (string.length > 9) {
        range = NSMakeRange(6, 3);
        [parts addObject:[string substringWithRange:range]];
    }
    
    if (string.length > 13) {
        range = NSMakeRange(9, 4);
        [parts addObject:[string substringWithRange:range]];
    }
    
    NSInteger processedCount = range.location + range.length;
    if (processedCount < string.length) {
        range = NSMakeRange(processedCount, string.length - processedCount);
        [parts addObject:[string substringWithRange:range]];
    }
    
    return [parts componentsJoinedByString:@" "];
}

+(NSMutableArray *)allCharsInString:(NSString *)string {
    if (string.length <= 0) {
        return nil;
    }
    
    NSMutableArray *allChars = [NSMutableArray array];
    
    for (NSInteger i = 0; i < string.length; i++) {
        NSString *chara = [string substringWithRange:NSMakeRange(i, 1)];
        
        [allChars addObject:chara];
    }
    
    return allChars;
}

+(void)restrictTextField:(id<UITextInput>)textInput maxLength:(NSUInteger)maxLength {

    UITextField *textField = (UITextField *)textInput;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    BOOL shouldTrim = NO;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，简体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            shouldTrim = YES;
        }
    } else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        shouldTrim = YES;
    }
    
    if (shouldTrim) {
        if (toBeString.length > maxLength) {
            textField.text = [toBeString substringToIndex:maxLength];
        }
    }
}

+(BOOL)checkHanCharacters:(NSString *)string {
    
    __block BOOL allIsValid = YES;
    NSArray *allChars = [self allCharsInString:string];
    [allChars enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isChar = [GGPredicate checkCharacter:obj];
        BOOL isHan = [GGPredicate containsHan:obj];
        NSLog(@"isChar:%@, isHan:%@, char:%@, len:%@", @(isChar), @(isHan), obj, @(obj.length));
        if (!isChar && !isHan) {
            allIsValid = NO;
            *stop = YES;
        }
    }];
    
    return allIsValid;
}

+(BOOL)checkNoEmojiCharacters:(NSString *)string {
    
    __block BOOL allIsValid = YES;
    NSArray *allChars = [self allCharsInString:string];
    [allChars enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isChar = [GGPredicate checkCharacter:obj];
        
        NSLog(@"isChar:%@, char:%@, len:%@", @(isChar), obj, @(obj.length));
        
        if (!isChar && obj.length > 1) {
            allIsValid = NO;
            *stop = YES;
        }
    }];
    
    return allIsValid;
}

+(UIFont *)boldFont:(UIFont *)font {
    if (font) {
        return [UIFont boldSystemFontOfSize:font.pointSize];
    }
    
    return nil;
}

+(BOOL)isContainsEmoji:(NSString *)string {
    
    NSString *str = @"➋➌➍➎➏➐➑➒";
    if ([str rangeOfString:string].length > 0) {
        return NO;
    }
    
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         
         
         
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 isEomji = YES;
                 
             }
             
             
             
         } else {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 
                 isEomji = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 isEomji = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 isEomji = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 
                 isEomji = YES;
                 
             }
             
         }
         
     }];
    
    
    
    return isEomji;
    
}


+(void)routeToPath:(NSString *)path paramString:(NSString *)paramString {
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", JP_ROUTE_SCHEME_HEAD, path];
    if (paramString.length > 0) {
        fullPath = [fullPath stringByAppendingFormat:@"?%@", paramString];
    }
    NSURL *url = [NSURL URLWithString:fullPath];
    
    [[UIApplication sharedApplication] openURL:url];
}

+(NSString *)stringByConvertReturnTagFromHTMLString:(NSString *)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    return htmlString;
}

@end
