//
//  DymRequest+Helper.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest+Helper.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPAppStatus.h"
#import <UnipeiApp-Swift.h>

static const DDLogLevel ddLogLevel = DDLogLevelDebug;
//static const DDLogLevel ddLogLevel = DDLogLevelError;

@implementation DymRequest (Helper)


#pragma mark - common api signals

+(RACSignal *)commonApiSignalWithClass:(Class)apiClass queue:(NSMutableArray *)apiQueue
                                params:(NSDictionary *)params {
    return [self commonApiSignalWithClass:apiClass queue:apiQueue params:params waitingMessage:nil preBlock:nil successBlock:nil failedBlock:nil];
}

+(RACSignal *)commonApiSignalWithClass:(Class)apiClass queue:(NSMutableArray *)apiQueue
                                params:(NSDictionary *)params
                        waitingMessage:(NSString *)waitingMessage {
    return [self commonApiSignalWithClass:apiClass queue:apiQueue params:params waitingMessage:waitingMessage preBlock:nil successBlock:nil failedBlock:nil];
}

+(RACSignal *)commonApiSignalWithClass:(Class)apiClass queue:(NSMutableArray *)apiQueue
                                params:(NSDictionary *)params
                        waitingMessage:(NSString *)waitingMessage
                              preBlock:(void(^)(void))preBlock {
    
    return [self commonApiSignalWithClass:apiClass queue:apiQueue params:params waitingMessage:waitingMessage preBlock:preBlock successBlock:nil failedBlock:nil];
};

+(RACSignal *)commonApiSignalWithClass:(Class)apiClass queue:(NSMutableArray *)apiQueue
                                params:(NSDictionary *)params
                        waitingMessage:(NSString *)waitingMessage
                              preBlock:(void(^)(void))preBlock
                          successBlock:(void(^)(void))successBlock
                           failedBlock:(void(^)(void))failedBlock {
    
    if (![apiClass isSubclassOfClass:[DymRequest class]]) {
        return nil;
    }
    
    id api = [[apiClass alloc] initWithParams:params];
    
    return [self commonApiSignal:api queue:apiQueue waitingMessage:waitingMessage preBlock:preBlock successBlock:successBlock failedBlock:failedBlock];
};



#pragma mark -
+(RACSignal *)commonApiSignal:(DymRequest *)api queue:(NSMutableArray *)apiQueue {
    
    return [self commonApiSignal:api queue:apiQueue waitingMessage:nil preBlock:nil successBlock:nil failedBlock:nil];
}

+(RACSignal *)commonApiSignal:(DymRequest *)api queue:(NSMutableArray *)apiQueue
               waitingMessage:(NSString *)waitingMessage {
    return [self commonApiSignal:api queue:apiQueue waitingMessage:waitingMessage preBlock:nil successBlock:nil failedBlock:nil];
}

+(RACSignal *)commonApiSignal:(DymRequest *)api queue:(NSMutableArray *)apiQueue
               waitingMessage:(NSString *)waitingMessage
                     preBlock:(void(^)(void))preBlock {
    return [self commonApiSignal:api queue:apiQueue waitingMessage:waitingMessage preBlock:preBlock successBlock:nil failedBlock:nil];
}

+(RACSignal *)commonApiSignal:(DymRequest *)api queue:(NSMutableArray *)apiQueue
               waitingMessage:(NSString *)waitingMessage
                     preBlock:(void(^)(void))preBlock
                 successBlock:(void(^)(void))successBlock
                  failedBlock:(void(^)(void))failedBlock {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (waitingMessage.length > 0) {
            [SVProgressHUD showWithStatus:waitingMessage];
        }
        
        if (preBlock) {
            preBlock();
        }
        
        [apiQueue addObject:api];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            
            if (waitingMessage.length > 0) {
                [SVProgressHUD dismiss];
            }
            
            if (successBlock) {
                successBlock();
            }
            
            if (!request.requestOperation.cancelled) {
                
                DDLogDebug(@"\n\n----------------♦︎Request OK♦︎------------------------\n♦︎Opertation:\n%@\n♦︎Arguments:\n%@\n♦︎Headers:\n%@\n\n", api.requestOperation, api.requestArgument, api.requestHeaderFieldValueDictionary);

                DDLogDebug(@"\n\n----------------♦︎Response♦︎-----------------------\n%@\n\n", api.responseString);
                
                id result = api.responseModel;
                [subscriber sendNext:result];
                [subscriber sendCompleted];
                
                /// 检查code, 如果出现code == 300，强制用户退出登录
                if ([result isKindOfClass:[DymBaseRespModel class]]) {
                    DymBaseRespModel *identifiedResult = result;
                    if ([identifiedResult.code integerValue] == 300) {
                        
                        [JPAppStatus logout];
                        
                        [[JLToast makeText:identifiedResult.msg] show];
                    }
                }
            }
            
        } failure:^(YTKBaseRequest *request) {
            
            DDLogDebug(@"\n\n----------------♦︎Request FAILED♦︎------------------------\n♦︎Opertation:\n%@\n♦︎Arguments:\n%@\n♦︎Headers:\n%@\n\n", api.requestOperation, api.requestArgument, api.requestHeaderFieldValueDictionary);
            
            if (waitingMessage.length > 0) {
                [SVProgressHUD dismiss];
            }
            
            if (failedBlock) {
                failedBlock();
            }
            
            NSError *error = [request timeoutError];
            [[JLToast makeTextQuick:error.domain] show];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}


@end
