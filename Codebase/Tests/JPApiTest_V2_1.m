//
//  JPApiTest_V2_1.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/18.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "JPApiTest_V2_1.h"
#import "DymCommonApi.h"
#import "DymRequest+Helper.h"
#import "JPAppStatus.h"
#import "NSString+GGAddOn.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UnipeiApp-Swift.h>

@implementation JPApiTest_V2_1

#pragma mark - 
-(void)showMessage:(NSString *)message {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", message);
        [[JLToast makeText:message] show];
    });
}

#pragma mark -test methods
-(void)testApiPath:(NSString *)path params:(NSDictionary *)params organIDKey:(NSString *)organIDKey organIdClass:(Class)organIdClass apiName:(NSString *)apiName {
    
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = path;
    api.params = params;
    if (organIDKey) {
        api.custom_organIdKey = organIDKey;
    }
    
    if (organIdClass) {
        api.custom_organIdClass = organIdClass;
    }
    
    NSString *waitingMessage = [NSString stringWithFormat:@"接口测试中：\n%@\n...", apiName];
    [[DymRequest commonApiSignal:api queue:nil waitingMessage:waitingMessage] subscribeNext:^(DymBaseRespModel *result) {
        
        NSString *message;
        if (result.success) {
            message = [NSString stringWithFormat:@"😁[%@ - 测试成功!]\n%@", apiName, api.relativePath];
        } else {
            message = [NSString stringWithFormat:@"😡[%@ - 测试失败!]\n%@\n错误码:%@, 消息:%@\n", apiName, api.relativePath, result.code, result.msg];
        }
        
        [self showMessage:message];
    }];
}

-(void)testGetBusiMsgList {
    
    [self testApiPath:@"remindApi/queryBusinessList.do"
               params:@{@"pageIndex": @1, @"pageSize": @20}
           organIDKey:@"organID" organIdClass:nil
              apiName:@"业务消息列表"];
}

-(void)testGetSysMsgList {
    
    [self testApiPath:@"remindApi/querySystemList.do"
               params:@{@"pageIndex": @1, @"pageSize": @20}
           organIDKey:@"organID" organIdClass:nil
              apiName:@"系统消息列表"];
}

-(void)testGetSysMsgDetailByID {
    
    [self testApiPath:@"remindApi/querySystemView.do"
               params:@{@"remindID": @95, @"userID": [JPAppStatus loginInfo].userID}
           organIDKey:nil organIdClass:nil
              apiName:@"系统消息详情By:ID"];
}

-(void)testGetLastRemind {
    
    [self testApiPath:@"remindApi/queryLastRemind.do"
               params:nil
           organIDKey:@"organID" organIdClass:nil
              apiName:@"获取修理厂最新消息"];
}

-(void)testGetCouponList {
    
    [self testApiPath:@"inquiryApi/findCouponList.do"
               params:@{@"amount": @200}
           organIDKey:@"ownerId" organIdClass:nil
              apiName:@"查询优惠券"];
}

-(void)testFindOrganAndUserInfo {
    
    [self testApiPath:@"userApi/findOrganAndUserInfo.do"
               params:@{@"username": [JPAppStatus loginInfo].loginUsername}
           organIDKey:nil organIdClass:nil
              apiName:@"查询修理厂信息"];
}

-(void)testUpdateOrganInfo {
    
    [self testApiPath:@"userApi/updateOrganInfo.do"
               params:@{@"id": [JPAppStatus loginInfo].organID, @"phone": @"15907108711"}
           organIDKey:nil organIdClass:nil
              apiName:@"修改帐号信息"];
}

-(void)testUpdatePassword {
    
    [self testApiPath:@"userApi/updatepassword.do"
               params:@{@"id": [JPAppStatus loginInfo].userID
                        , @"oldpassword": @"123456".md5Str, @"password": @"123456".md5Str}
           organIDKey:nil organIdClass:nil
              apiName:@"修改密码"];
}

-(void)testAllDealerList {
    
    [self testApiPath:@"dealerApi/allDealerList.do"
               params:@{@"unionID": [JPAppStatus loginInfo].unionID
                        , @"pageIndex": @1, @"pageSize": @5, @"isCommonParts": @1}
           organIDKey:nil organIdClass:nil
              apiName:@"查询经销商列表"];
}


-(void)testGetSysDealer {
    
    [self testApiPath:@"dealerApi/getSysDealer.do"
               params:@{@"orgId": @170188}
           organIDKey:nil organIdClass:nil
              apiName:@"获取经销商详情"];
}

//
-(void)testFindBrandListDealer {
    
    [self testApiPath:@"commonApi/findBrandListDealer.do"
               params:@{@"unionID": [JPAppStatus loginInfo].unionID}
           organIDKey:nil organIdClass:nil
              apiName:@"经销商品牌列表"];
}

//
-(void)testSearchDealer {
    
    [self testApiPath:@"dealerApi/searchDealer.do"
               params:@{@"pageIndex": @1, @"pageSize": @5
                        , @"unionID": [JPAppStatus loginInfo].unionID
                        , @"makeIds": @36000000}
           organIDKey:nil organIdClass:nil
              apiName:@"搜索品牌经销商"];
}

@end
