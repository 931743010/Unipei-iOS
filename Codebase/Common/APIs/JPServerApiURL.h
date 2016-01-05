//
//  ServerApiURL.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <Foundation/Foundation.h>


//static NSString *PATH_Api_base_url = @"http://172.23.3.47:8080/commonApi/";
//static NSString *PATH_Api_base_url = @"http://172.23.3.111:8080/commonApi/";      // 测试
//static NSString *PATH_Api_base_url = @"http://59.172.62.234:20004/commonApi/";      // 武汉测试
//static NSString *PATH_Api_base_url = @"http://papi.unipei.com:8080/commonApi/";      // 线上

//static NSString *PATH_Api_base_url = @"http://172.23.2.89:8088/commonApi/";       // 孙夏晨

//static NSString *PATH_Image_base_url = @"http://172.23.16.80/";

//    return @"http://172.23.2.63:9080/commonApi/";  // 陈欢

//首页公告
static NSString *PATH_commonApi_getPapSysnoticeList = @"commonApi/getPapSysnoticeList.do";

//供应商
static NSString *PATH_dealerApi_allDealerList = @"dealerApi/allDealerList.do";
static NSString *PATH_dealerApi_searchDealer  = @"dealerApi/searchDealer.do";
static NSString *PATH_commonApi_findBrandListDealer = @"commonApi/findBrandListDealer.do";
static NSString *PATH_dealerApi_getSysDealer = @"dealerApi/getSysDealer.do";


/// 修理厂用户注册
static NSString *PATH_userApi_login = @"userApi/login.do";
static NSString *PATH_userApi_bindChannelID = @"userApi/bindChannelID.do";
static NSString *PATH_userApi_saveApplyService = @"userApi/saveApplyService.do";

//个人信息相关
static NSString *PATH_userApi_updatepassword = @"userApi/updatepassword.do";
static NSString *PATH_userApi_findOrganAndUserInfo = @"userApi/findOrganAndUserInfo.do";
static NSString *PATH_userApi_updateOrganInfo = @"userApi/updateOrganInfo.do";
static NSString *PATH_userApi_getPerfectOrgan = @"userApi/getPerfectOrgan.do";
static NSString *PATH_userApi_putPerfectOrgan = @"userApi/putPerfectOrgan.do";

//退出登录
static NSString *PATH_userApi_unBindChannelID = @"userApi/unBindChannelID.do";
static NSString *PATH_commonApi_uploadImage = @"commonApi/uploadImage.do";
// PAP 2.0
static NSString *PATH_commonApi_findVersionInfo = @"commonApi/findVersionInfo.do";
static NSString *PATH_commonApi_getVinInfo = @"commonApi/getVinInfo.do";    //获取VIN码相关信息
static NSString *PATH_commonApi_findLogisticsList = @"commonApi/findLogisticsList.do";  // 物流公司列表


static NSString *PATH_modelPictureApi_findSeriesList = @"commonApi/findSeriesList.do";
static NSString *PATH_modelPictureApi_findYearList = @"commonApi/findYearList.do";
static NSString *PATH_modelPictureApi_findModelList = @"commonApi/findModelList.do";
static NSString *PATH_modelPictureApi_findMakeList = @"commonApi/findBrandList.do";
static NSString *PATH_modelPictureApi_findModelPictureList = @"modelPictureApi/findModelPictureList.do";


static NSString *PATH_demandApi_addDemand = @"demandApi/addDemand.do";
static NSString *PATH_demandApi_demandList = @"demandApi/demandList.do";


static NSString *PATH_bomPartsApi_queryPartsByOE = @"bomPartsApi/queryPartsByOE.do";
static NSString *PATH_bomPartsApi_queryPartsByName = @"bomPartsApi/queryPartsByName.do";
static NSString *PATH_bomPartsApi_queryModel = @"bomPartsApi/queryModel.do";
static NSString *PATH_bomPartsApi_getPartsDetail = @"bomPartsApi/getPartsDetail.do";
static NSString *PATH_bomPartsApi_addQuotation = @"bomPartsApi/addQuotation.do";
static NSString *PATH_bomPartsApi_editQuotation = @"bomPartsApi/editQuotation.do";
static NSString *PATH_bomPartsApi_loadHistoryQuotation = @"bomPartsApi/loadHistoryQuotation.do";
static NSString *PATH_bomPartsApi_getQuotation = @"bomPartsApi/getQuotation.do";


static NSString *PATH_inquiryApi_findCarNumber = @"inquiryApi/findCarNumber.do";
static NSString *PATH_inquiryApi_getProvinceAndDef = @"inquiryApi/getProvinceAndDef.do";
static NSString *PATH_inquiryApi_findDealInfoByMakes = @"inquiryApi/findDealInfoByMakes.do";
static NSString *PATH_inquiryApi_addInquiry = @"inquiryApi/addInquiry.do";
static NSString *PATH_inquiryApi_findInquiryListBySerViceID = @"inquiryApi/findInquiryListBySerViceID.do";
static NSString *PATH_inquiryApi_findInquiryByinquiryID = @"inquiryApi/findInquiryByinquiryID.do";
static NSString *PATH_inquiryApi_addServiceAddress = @"inquiryApi/addServiceAddress.do";
static NSString *PATH_inquiryApi_findServiceAddress = @"inquiryApi/findServiceAddress.do";
static NSString *PATH_inquiryApi_editInquiryCarNum = @"inquiryApi/editInquiryCarNum.do";
static NSString *PATH_inquiryApi_findDealerListByInquiryID = @"inquiryApi/findDealerListByInquiryID.do";
static NSString *PATH_inquiryApi_delServiceAddress = @"inquiryApi/delServiceAddress.do";


/// PAP 2.0 API
static NSString *PATH_inquiryApi_findGcategory = @"inquiryApi/findGcategory.do";
static NSString *PATH_inquiryApi_findGcategoryChild = @"inquiryApi/findGcategoryChild.do";
static NSString *PATH_inquiryApi_findGcategoryGrandchild = @"inquiryApi/findGcategoryGrandchild.do";
static NSString *PATH_inquiryApi_inquiryAdd = @"inquiryApi/inquiryAdd.do";
static NSString *PATH_inquiryApi_choiceDealer = @"inquiryApi/choiceDealer.do";

//static NSString *PATH_inquiryApi_inquiryList = @"inquiryApi/inquiryList.do";    // 询价单列表
static NSString *PATH_inquiryApi_inquiryList = @"inquiryApi/findInquiryList.do";    // 询价单列表

static NSString *PATH_inquiryApi_inquiryEditState = @"inquiryApi/inquiryEditState.do";
static NSString *PATH_inquiryApi_inquiryDetail = @"inquiryApi/inquiryDetail.do";    // 详情
static NSString *PATH_inquiryApi_findQuotation = @"inquiryApi/findQuotation.do";
static NSString *PATH_inquiryApi_getInquiryInfo = @"inquiryApi/getInquiryInfo.do";  // Info
static NSString *PATH_inquiryApi_getScheme = @"inquiryApi/getScheme.do";
static NSString *PATH_inquiryApi_inquiryListUpdate = @"inquiryApi/inquiryListUpdate.do";
static NSString *PATH_inquiryApi_commitOrder = @"inquiryApi/commitOrder.do";
static NSString *PATH_inquiryApi_lottery = @"inquiryApi/lottery.do";

static NSString *PATH_inquiryApi_addReciveAddress = @"inquiryApi/addReceiveAddress.do";
static NSString *PATH_inquiryApi_updateReciveAddress = @"inquiryApi/updateReceiveAddress.do";
static NSString *PATH_inquiryApi_updateDefaultAddress = @"inquiryApi/updateDefaultAddress.do";
static NSString *PATH_inquiryApi_findReceiveAddressById = @"inquiryApi/findReceiveAddressById.do";
static NSString *PATH_inquiryApi_findReceiveAddress = @"inquiryApi/findReceiveAddress.do";
static NSString *PATH_inquiryApi_deleteReceiveAddressById = @"inquiryApi/deleteReceiveAddressById.do";


static NSString *PATH_inquiryApi_findState = @"inquiryApi/findState.do";
static NSString *PATH_inquiryApi_findCity = @"inquiryApi/findCity.do";
static NSString *PATH_inquiryApi_findDistrict = @"inquiryApi/findDistrict.do";
static NSString *PAth_inquiryApi_Coupon =@"commonApi/getCouponManage.do";//优惠劵

/// 订单相关
static NSString *PATH_orderApi_orderList = @"orderApi/orderList.do";    // 订单列表
static NSString *PATH_orderApi_orderFormDetails = @"orderApi/orderFormDetails.do";  // 订单详情
static NSString *PATH_orderApi_getSysGoods = @"orderApi/getSysGoods.do";    // 订单商品详情
static NSString *PATH_orderApi_orderCancel = @"orderApi/orderCancel.do";    // 取消订单
static NSString *PATH_orderApi_orderStatusCount = @"orderApi/orderStatusCount.do";    // 订单状态数量
static NSString *PATH_orderApi_orderTrail = @"orderApi/orderTrail.do";    // 查看订单轨迹
static NSString *PATH_orderApi_orderConfirm = @"orderApi/orderConfirm.do";    // 确认收货



/// 报价单相关
static NSString *PATH_quotationApi_findAppQuotationConfirmByQuotationID = @"quotationApi/findAppQuotationConfirmByQuotationID.do";
static NSString *PATH_quotationApi_quotationConfirm = @"quotationApi/quotationConfirm.do";
static NSString *PATH_quotationApi_quotationRefuse = @"quotationApi/quotationRefuse.do";


//信息中心相关
static NSString *PATH_remindApi_queryBusinessList = @"remindApi/queryBusinessList.do";
static NSString *PATH_remindApi_querySystemList = @"remindApi/querySystemList.do";
static NSString *PATH_remindApi_querySystemView = @"remindApi/querySystemView.do";  //  根据remindID查消息详情
static NSString *PATH_remindApi_querySystemViewByNotification = @"remindApi/querySystemViewByNotification.do";  //  根据batchID查消息详情
static NSString *PATH_remindApi_delBusinessRemind = @"remindApi/delBusinessRemind.do";//删除业务消息
static NSString *PATH_remindApi_queryLastRemind = @"remindApi/queryLastRemind.do";

///
typedef NS_ENUM(NSInteger, EJPServerEnv) {
    kJPServerEnvTest = 0                    // 测试111
    , kJPServerEnvTestWuhan                 // 测试-外网
    , kJPServerEnvProduction                // 线上
    , kJPServerEnvTestDepartment            // 测试部
    , kJPServerEnvTestBeijing               // 测试-北京
};

typedef NS_ENUM(NSInteger, EJPFileServerEnv) {
    kJPFileServerEnvTest = 0                // 测试
    , kJPFileServerEnvProduction            // 线上
    , kJPFileServerEnvTestDepartment        // 测试部
    , kJPFileServerEnvTestBeijing           // 测试-北京
};

@interface JPServerApiURL : NSObject

+(EJPServerEnv)serverEnv;

+(void)setServerEnvironment:(EJPServerEnv)serverEnv;

+(NSArray *)serverURLs;

+(NSString *)descriptionForEnv:(EJPServerEnv)serverEnv;

+(NSString *)baseURL;

+(NSString *)fileServerURL;

@end
