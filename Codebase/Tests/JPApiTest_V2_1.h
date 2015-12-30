//
//  JPApiTest_V2_1.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/18.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPApiTest_V2_1 : NSObject

/// 接口测试：获取业务消息列表
-(void)testGetBusiMsgList;
/// 接口测试：获取系统消息列表
-(void)testGetSysMsgList;
/// 接口测试：获取系统消息详情By:ID
-(void)testGetSysMsgDetailByID;
/// 接口测试：获取修理厂最新消息
-(void)testGetLastRemind;
/// 接口测试：查询优惠券
-(void)testGetCouponList;
/// 接口测试：查询修理厂信息
-(void)testFindOrganAndUserInfo;
/// 接口测试：修改帐号信息
-(void)testUpdateOrganInfo;
/// 接口测试：修改密码
-(void)testUpdatePassword;
/// 接口测试：查询经销商列表
-(void)testAllDealerList;
/// 接口测试：获取经销商详情
-(void)testGetSysDealer;
/// 接口测试：经销商品牌列表
-(void)testFindBrandListDealer;
/// 接口测试：搜索品牌经销商
-(void)testSearchDealer;
/// 接口测试：抽奖
//-(void)testDrawLottery;
@end
