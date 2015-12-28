//
//  UNPDeveloperVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPDeveloperVC.h"
#import "DymStoryboard.h"
#import "OrderApi_OrderList.h"
#import "UNPOrderDetailVC.h"
#import "JPApiTest_V2_1.h"
#import "JPSidePopVC.h"
#import <Masonry/Masonry.h>
#import "UNPIntroVC.h"
#import "LotteryDrawViewController.h"
#import "OfferInqueryResultFor4sViewController.h"


@interface UNPDeveloperVC () {
    NSArray             *_testCases;
    JPApiTest_V2_1      *_tester;
}

@end



@implementation UNPDeveloperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试页面";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //
    _tester = [JPApiTest_V2_1 new];
    _testCases = @[
                   @{@"name":@"接口测试：获取业务消息列表"
                     , @"method":@"testGetBusiMsgList"}
                   
                   , @{@"name":@"接口测试：获取系统消息列表"
                       , @"method":@"testGetSysMsgList"}
                   
                   , @{@"name":@"接口测试：获取系统消息详情By:ID"
                       , @"method":@"testGetSysMsgDetailByID"}
                   
                   , @{@"name":@"接口测试：获取修理厂最新消息"
                       , @"method":@"testGetLastRemind"}
                   
                   , @{@"name":@"接口测试：查询优惠券"
                       , @"method":@"testGetCouponList"}
                   
                   , @{@"name":@"接口测试：查询修理厂信息"
                       , @"method":@"testFindOrganAndUserInfo"}
                   
                   , @{@"name":@"接口测试：修改帐号信息"
                       , @"method":@"testUpdateOrganInfo"}
                   
                   , @{@"name":@"接口测试：修改密码"
                       , @"method":@"testUpdatePassword"}
                   
                   , @{@"name":@"接口测试：查询经销商列表"
                       , @"method":@"testAllDealerList"}
                   
                   , @{@"name":@"接口测试：获取经销商详情"
                       , @"method":@"testGetSysDealer"}
                   
                   , @{@"name":@"接口测试：经销商品牌列表"
                       , @"method":@"testFindBrandListDealer"}
                   
                   , @{@"name":@"接口测试：搜索品牌经销商"
                       , @"method":@"testSearchDealer"}
                   , @{@"name":@"接口测试：搜索品牌经销商"
                       , @"method":@"testSearchDealer"}
                   ];
}


#pragma mark -tableview 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return _testCases.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //测试抽奖
    if(indexPath.row==0){
        [self testDrawLottery];
//         [self testOfferInquery4s];
     return;
    }
    
    if (indexPath.section == 0) {
        
        UNPIntroVC *vc = [UNPIntroVC new];
        [self presentViewController:vc animated:NO completion:nil];
        
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_tester performSelector:NSSelectorFromString(_testCases[indexPath.row][@"method"])];
#pragma clang diagnostic pop
    
    DymBaseVC *vc = [DymBaseVC new];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:vc action:@selector(dismissPopView)];
    vc.navigationItem.leftBarButtonItem = barBtn;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];

    [[JPSidePopVC new] showVC:nc];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"引导页面";
        
        return cell;
    }
    
    cell.textLabel.text = _testCases[indexPath.row][@"name"];
    
    return cell;
}




#pragma mark 测试方法
-(void)testDrawLottery{
    
    LotteryDrawViewController *lotteryDrawVC = (LotteryDrawViewController *)[UNPDeveloperVC viewFromStoryboard];
    [self.navigationController pushViewController:lotteryDrawVC animated:YES];
    NSLog(@"===%s",__FUNCTION__);
}

+(instancetype)viewFromStoryboard {
    return [[DymStoryboard unipei_Lottery_Storyboard] instantiateViewControllerWithIdentifier:@"lotterydraw"];
}
-(void)testOfferInquery4s{
    OfferInqueryResultFor4sViewController *offerVC = (OfferInqueryResultFor4sViewController *)
    [[DymStoryboard unipei_Lottery_Storyboard] instantiateViewControllerWithIdentifier:@"offerInquery4s"];
    
     [self.navigationController pushViewController:offerVC animated:YES];
}




@end
