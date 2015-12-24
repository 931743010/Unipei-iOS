//
//  DymRequest+Helper.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@class RACSignal;


@interface DymRequest (Helper)


+(RACSignal *)commonApiSignalWithClass:(Class)apiClass queue:(NSMutableArray *)apiQueue
                                params:(NSDictionary *)params;

+(RACSignal *)commonApiSignalWithClass:(Class)apiClass queue:(NSMutableArray *)apiQueue
                                params:(NSDictionary *)params
                        waitingMessage:(NSString *)waitingMessage;

+(RACSignal *)commonApiSignalWithClass:(Class)apiClass queue:(NSMutableArray *)apiQueue
                                params:(NSDictionary *)params
                        waitingMessage:(NSString *)waitingMessage
                              preBlock:(void(^)(void))preBlock;

+(RACSignal *)commonApiSignalWithClass:(Class)apiClass queue:(NSMutableArray *)apiQueue
                                params:(NSDictionary *)params
                        waitingMessage:(NSString *)waitingMessage
                              preBlock:(void(^)(void))preBlock
                          successBlock:(void(^)(void))successBlock
                           failedBlock:(void(^)(void))failedBlock;

#pragma mark -
+(RACSignal *)commonApiSignal:(DymRequest *)api queue:(NSMutableArray *)apiQueue;

+(RACSignal *)commonApiSignal:(DymRequest *)api queue:(NSMutableArray *)apiQueue
               waitingMessage:(NSString *)waitingMessage;

+(RACSignal *)commonApiSignal:(DymRequest *)api queue:(NSMutableArray *)apiQueue
               waitingMessage:(NSString *)waitingMessage
                     preBlock:(void(^)(void))preBlock;

+(RACSignal *)commonApiSignal:(DymRequest *)api queue:(NSMutableArray *)apiQueue
               waitingMessage:(NSString *)waitingMessage
                     preBlock:(void(^)(void))preBlock
                 successBlock:(void(^)(void))successBlock
                  failedBlock:(void(^)(void))failedBlock;

@end
