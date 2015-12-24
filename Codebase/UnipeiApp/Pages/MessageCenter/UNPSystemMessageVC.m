//
//  UNPSystemMessageVC.m
//  DymIOSApp
//
//  Created by xujun on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//
#define PageSize 20

#import "UNPSystemMessageVC.h"
#import "UNPMessageOrderCell.h"
#import "UNPSystemMessageDetailVC.h"
#import "JPAppStatus.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <UnipeiApp-Swift.h>

@interface UNPSystemMessageVC () {
    NSMutableArray           *_data;
    UIRefreshControl         *_refreshControl;
    CGFloat                   _page;
    BOOL                      _hasMore;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UNPSystemMessageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _page = 1;
    _hasMore = YES;
    
    /// 消红点
    [JPAppStatus setHasNewSystemMessage:NO];
    
    @weakify(self)
    
    _data = [NSMutableArray arrayWithCapacity:PageSize];
    
    self.navigationItem.title = @"系统消息";
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 120;
    
    // 上下拉刷新
    _refreshControl = [[UIRefreshControl alloc] init];
    [_tableView addSubview:_refreshControl];
    [[_refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self getFirstPage];
    }];
    
    //
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
    
    [self getSystemMessageData];
    
    [_refreshControl beginRefreshing];
    _tableView.showsInfiniteScrolling = NO;
}

-(void)getNextPage {
    if (_hasMore) {
        _page ++;
        [self getSystemMessageData];
    }
}

-(void)getSystemMessageData {

    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_remindApi_querySystemList;
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
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //填充数据
    id item = _data[indexPath.row];
    cell.lblClassify.text = item[@"title"];
    cell.lblTime.text = item[@"createTime"];
    cell.lblMessageTitle.text = item[@"content"];

    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UNPSystemMessageDetailVC *vc = [UNPSystemMessageDetailVC newFromStoryboard];
    vc.messageID = [[_data objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
