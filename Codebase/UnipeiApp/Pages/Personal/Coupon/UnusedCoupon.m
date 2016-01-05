//
//  UnusedCoupon.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/22.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UnusedCoupon.h"
#import "UnusedCouponCell.h"
#import "UsedCouponCell.h"
#import "JPAppStatus.h"
#import "CouponModelManager.h"
#import <MJRefresh.h>

typedef NS_ENUM(NSInteger, EJPCouponState) {
    kJPCouponStateAvailable = 0
    , kJPCouponStateUsed = 1
    , kJPCouponStateOutOfDate =2
};
@interface UnusedCoupon ()<UITableViewDataSource,UITableViewDelegate>
{
    int       _page;
    NSString *_typeStr;
}
@property (weak, nonatomic) IBOutlet UITableView *unUsedTable;
@end

@implementation UnusedCoupon
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化页面的类型
    if (self.typeCoupon == kJPCouponStateAvailable) {
        _typeStr = [@(kJPCouponStateAvailable) stringValue];
    }else if (self.typeCoupon == kJPCouponStateUsed){
        _typeStr = [@(kJPCouponStateUsed) stringValue];
    }else{
        _typeStr = [@(kJPCouponStateOutOfDate) stringValue];
    }
    _page = 1;
    [self loadData:_page];
    
    //设置unUsedTable相关属性
    self.unUsedTable.delegate = self;
    self.unUsedTable.dataSource = self;
    self.unUsedTable.showsVerticalScrollIndicator = NO;
    [self.unUsedTable registerNib:[UINib nibWithNibName:@"UnusedCouponCell" bundle:nil]forCellReuseIdentifier:@"cellName"];
    [self.unUsedTable registerNib:[UINib nibWithNibName:@"MoreCell" bundle:nil]forCellReuseIdentifier:@"moreCell"];
    [self.unUsedTable registerNib:[UINib nibWithNibName:@"UsedCouponCell" bundle:nil]forCellReuseIdentifier:@"cellID"];
    [self creatRefresh];
    
}
// Pull to Refresh
-(void)creatRefresh{
    self.unUsedTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
    
    self.unUsedTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh)];
}
//上拉加载
-(void)upRefresh{
    _page++;
    [self loadData:_page];
    
}
//下拉刷新
-(void)downRefresh{
    if (self.dateArray.count>0) {
        //先删除旧数据
        [self.dateArray removeAllObjects];
    }
    [self loadData:1];
}
-(NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        self.dateArray = [[NSMutableArray alloc]init];
    }
    return _dateArray;
}
#pragma mark - 加载数据
-(void)loadData:(int)page{
    @weakify(self);
    DymCommonApi *api = [DymCommonApi new];
    api.apiVersion = @"V2.2";
    api.custom_organIdClass = [NSString class];
    api.relativePath = PAth_inquiryApi_Coupon;
    api.params = @{@"state":_typeStr
                   ,@"page":[@(page) stringValue],@"pageSize":@"10"};
    [[DymRequest commonApiSignal:api queue:nil] subscribeNext:^(DymBaseRespModel *result) {
        @strongify(self);
        if (result.success) {
            [self.dateArray addObjectsFromArray:[CouponModelManager arrayWithDic:result.body]];
            //如果请求的数据比10小则不显示尾部
            if ([CouponModelManager arrayWithDic:result.body].count < 10) {
                self.unUsedTable.footer = nil;
            }
            [self.unUsedTable reloadData];
            [self.unUsedTable.header endRefreshing];
            [self.unUsedTable.footer endRefreshing];
        }
        
        [self showEmptyView:self.dateArray.count == 0 text:@"暂无优惠劵"];
    }];
 
}
#pragma mark -UITableViewDataSource代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateArray.count;
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.typeCoupon == kJPCouponStateAvailable) {
        UnusedCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellName"];
        if (self.dateArray.count >0) {
            [cell configWithModel:self.dateArray[indexPath.row]];
        }
        
        return cell;
    }else{
        UsedCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (self.dateArray.count >0) {
            [cell configWithModel:self.dateArray[indexPath.row]];
        }
        return cell;
    }
   
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
