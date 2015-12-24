//
//  UNPBusinessMessageVC.m
//  DymIOSApp
//
//  Created by xujun on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//
#define PageSize 20

#import "UNPBusinessMessageVC.h"
#import "UNPMessageOrderCell.h"
#import "JPAppStatus.h"
#import "UNPOrderDetailVC.h"
#import "UNPMyInquiryVC.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <UnipeiApp-Swift.h>

@interface UNPBusinessMessageVC ()
{
    NSMutableArray           *_data;
    UIRefreshControl         *_refreshControl;
    CGFloat                   _page;
    BOOL                      _hasMore;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UNPBusinessMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _hasMore = YES;
    
    /// 消红点
    [JPAppStatus setHasNewBusinessMessage:NO];
    
    @weakify(self)
    
    _data = [NSMutableArray arrayWithCapacity:PageSize];
    
    self.navigationItem.title = @"业务消息";
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 120;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 上下拉刷新
    _refreshControl = [[UIRefreshControl alloc] init];
    [_tableView addSubview:_refreshControl];
    [[_refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self getFirstPage];
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [self getNextPage];
    }];
    
    [self getFirstPage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFirstPage) name:JP_NOTIFICATION_NEW_MESSAGE_STATE_CHANGED object:nil];
}

#pragma mark - Pravite
-(void)getFirstPage {
    _page = 1;
    _hasMore = YES;
    
    [self getBusinessMessageData];
    
    [_refreshControl beginRefreshing];
    _tableView.showsInfiniteScrolling = NO;
}

-(void)getNextPage {
    if (_hasMore) {
        _page ++;
        [self getBusinessMessageData];
    }
}

-(void)getBusinessMessageData{
    
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_remindApi_queryBusinessList;
    api.params = @{@"pageIndex":@(_page)};
    api.custom_organIdKey = @"organID";
    
    @weakify(self)
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        
        @strongify(self)
        
        
        if (self->_page <= 1) {
            [self->_data removeAllObjects];
        }
        
        if (result.success) {
            /// 将oder改为mutable
            NSMutableArray *mutableOrders = [NSMutableArray array];
            [result.body[@"remindList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [mutableOrders addObject:[obj mutableCopy]];
                }
            }];
            
            [self->_data addObjectsFromArray:mutableOrders];
            
            if (mutableOrders.count <= 0) {
                self->_hasMore = NO;
                self->_tableView.showsInfiniteScrolling = NO;
                
                if (self->_page > 1) {
                    [[JLToast makeTextQuick:@"没有更多了"] show];
                }
                
            } else if (mutableOrders.count > 0 && mutableOrders.count < PageSize ) {
                // 如果返回的数据条数大于0但小于pageSize，就视为最后一页数据
                self->_hasMore = NO;
                self->_tableView.showsInfiniteScrolling = NO;
                
            } else {
                self->_hasMore = YES;
                self->_tableView.showsInfiniteScrolling = YES;
            }
            
            [self->_refreshControl endRefreshing];
            [self->_tableView.infiniteScrollingView stopAnimating];
            
        } else {
            self->_tableView.showsInfiniteScrolling = NO;
            [self->_tableView.infiniteScrollingView stopAnimating];
            [self->_refreshControl endRefreshing];
        }
        
        [self->_tableView reloadData];
        
        [self showEmptyView:(self->_data.count <= 0) text:@"暂无消息数据"];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDatasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"UNPMessageOrderCell";
    
    BOOL nibsRegisterd = NO;
    
    if (!nibsRegisterd) {
        
        UINib *nib = [UINib nibWithNibName:@"UNPMessageOrderCell" bundle:nil];
        
        [tableView registerNib:nib forCellReuseIdentifier:cellid];
        
        nibsRegisterd = YES;
    }
    
    UNPMessageOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //填充数据
    cell.lblClassify.text = [[_data objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.lblTime.text = [[_data objectAtIndex:indexPath.row] objectForKey:@"createTime"];
    cell.lblMessageTitle.text = [[_data objectAtIndex:indexPath.row] objectForKey:@"content"];
    
    return cell;

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    {"remindList":[{"content":"您向济南凯鹰汽配商行下的订单DD1532793934已发货，请注意收货!","id":9564,"createTime":"2015-11-23 16:56","organType":3,"title":"温馨提示","linkUrl":"/pap/orderreview/detail/orderid/2307","promoterType":2,"handleType":2,"handleID":2307,"msgType":1,"effectiveTime":1448441801,"organID":174585,"promoterID":169337,"handleStatus":0}]}
    
//    {"content":"济南凯鹰汽配商行向您发布了报价单,单号为BJ144826999882846。请注意确认!","id":9566,"createTime":"2015-11-23 17:13","organType":3,"title":"温馨提示","linkUrl":"/pap/inquiryorder/inquirydetail/inquiryID/2917","promoterType":2,"handleType":3,"handleID":"2917","msgType":2,"effectiveTime":1448442814,"organID":174585,"promoterID":169337,"handleStatus":0}
    
    id item = _data[indexPath.row];
    long long handleID = [item[@"handleID"] longLongValue];
    
    EJPPushMessageType pushMessageType = [item[@"msgType"] integerValue];
    if (pushMessageType == kJPPushMessageTypeOrder) {
        
        UNPOrderDetailVC *vc = [UNPOrderDetailVC newFromStoryboard];
        vc.orderID = @(handleID);
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (pushMessageType == kJPPushMessageTypeQuatationInquiry) {
        
        UNPMyInquiryVC *vc = [UNPMyInquiryVC newFromStoryboard];
        vc.inquiryID = @(handleID);
        vc.inquiryType = kJPInquiryTypeInquiry;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (pushMessageType == kJPPushMessageTypeQuatationDealer) {
        
        UNPMyInquiryVC *vc = [UNPMyInquiryVC newFromStoryboard];
        vc.inquiryID = @(handleID);
        vc.inquiryType = kJPInquiryTypeNoInquiry;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    NSLog(@"%@", item);
    
}
/// 删除
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return YES;
//
//}
//-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UITableViewRowAction *delet = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        DymCommonApi *api = [DymCommonApi new];
//        api.relativePath = PATH_remindApi_delBusinessRemind;
//        api.params = @{@"remindID":_data[indexPath.row][@"id"]};
//        
//        __weak typeof(self) weakSelf = self;
//        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result){
//        
//            __strong typeof(self) strongSelf = weakSelf;
//            if (result.success) {
//                
//                [_data removeObjectAtIndex:indexPath.row];
//                [strongSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                
//            }
//            
//        }];
//
//    }];
//    
////    UITableViewRowAction *top = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
////        
////    }];
////    
////    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"更多" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
////        
////    }];
//    
//    return @[delet];
//    
//}

@end
