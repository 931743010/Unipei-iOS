//
//  UNPInquirySheetsVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPInquiriesVC.h"
#import "JPMyInquiryItemCell.h"
#import "JPSensibleButton.h"
#import "DymStoryboard.h"
#import "DymNavigationController.h"
#import "UNPMyInquiryVC.h"
#import "JPSidePopVC.h"
#import "UNPInquiriesFilterVC.h"
#import "InquiryApi_InquiryList.h"
#import "InquiryApi_InquiryAdd.h"
#import "InquiryApi_InquiryEditState.h"
#import "JPAppStatus.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <UnipeiApp-Swift.h>
#import "JPUtils.h"
#import "UNPCreateInquiryVC.h"

//static const DDLogLevel ddLogLevel = DDLogLevelDebug;

static const CGFloat    pageSize = 20;

@interface UNPInquiriesVC () <UIGestureRecognizerDelegate, JPMyInquiryItemCellDelegate> {
    
    CGFloat                 _pageIndex;  // start from 1
    
    NSMutableArray          *_inquiries;
    
    BOOL                    _hasMore;
    
    UIRefreshControl        *_refreshControl;
    
    InquiryApi_InquiryList  *_apiInquiryList;
    
    BOOL                    _hasRequestedInquiryList;
}

@end

@implementation UNPInquiriesVC

- (void)viewDidLoad {
    
    _hasMore = YES;
    _pageIndex = 1;
    
    [super viewDidLoad];
    
    self.emptyMessage = @"暂无询价单";
    
    @weakify(self)
    _inquiries = [NSMutableArray arrayWithCapacity:pageSize];
    
    // Filter inquiry button
    JPSensibleButton *btnFilter = [[JPSensibleButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [btnFilter setImage:[UIImage imageNamed:@"btn_filter"] forState:UIControlStateNormal];
    [[btnFilter rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self)
//        [self closeCellsExcept:nil];
        UNPInquiriesFilterVC *vc = [UNPInquiriesFilterVC newFromStoryboard];
        vc.filterData = self->_apiInquiryList;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [[JPSidePopVC new] showVC:nc];
    }];
    
    // Create inquiry button
    JPSensibleButton *btnAdd = [[JPSensibleButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [btnAdd setImage:[UIImage imageNamed:@"btn_circle_add"] forState:UIControlStateNormal];
    [[btnAdd rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        [self createNewInquiry];
    }];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnFilter];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    
    
    // Pull to Refresh
    _refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_refreshControl];
    [[_refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self getFirstPage];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [self getNextPage];
    }];
    
    
    // requesting data
    [self resetFilterAndRequestData];
    
    
    /// Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFirstPageAndShowLoading) name:JP_NOTIFICATION_INQUIRY_FILTER_CHANGED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFirstPageAndShowLoading) name:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetFilterAndRequestData) name:JP_NOTIFICATION_INQUIRY_CHANGED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetFilterAndRequestData) name:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
}


-(void)createNewInquiry {
//    [self closeCellsExcept:nil];
    
    UNPCreateInquiryVC *vc = [UNPCreateInquiryVC newFromStoryboard];
    
    DymNavigationController *nc = [[DymNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - table view
-(BOOL)isDataSourceEmpty {
    return _hasRequestedInquiryList && _inquiries.count <= 0;
}

-(BOOL)allowBounceWhenDataSourceIsEmpty {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath_IfDataOK:(NSIndexPath *)indexPath {
    
    id inquiry = _inquiries[indexPath.row];
    if ([[inquiry objectForKey:@"status"] integerValue] == kJPInquiryStatusWaitingQuatation) {
        return 158;
    }
    
    return 120;//inquiryItemEditCell
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection_IfDataOK:(NSInteger)section {
    
    return _inquiries.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellSpecial = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cellSpecial == self.emptyCell || cellSpecial == self.loadingCell) {
        return cellSpecial;
    }
    
    id inquiry = _inquiries[indexPath.row];
    
//{"makeName":"上海大众","car":"","createTime":1443075212,"model":"","inquiryID":1141,"status":3,"dealerName":"济南金华东汽车配件有限公司","orderSn":"","dealerPhone":"15071179304","modelName":"","carName":"","inquirySn":"x1b0754cm335-1","year":"","dealerID":",169339,","make":"7000000"}
    
    NSInteger status = [[inquiry objectForKey:@"status"] integerValue];
    NSString *cellID = (status == kJPInquiryStatusWaitingQuatation) ? @"inquiryItemEditCell" : @"inquiryItemCell";
    
    JPMyInquiryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.contentView.tag = indexPath.row;
    cell.lblStatus.text = [InquiryApi_InquiryList stringWithInquiryStatus:status];
    cell.lblStatus.textColor = [InquiryApi_InquiryList colorWithInquiryStatus:status];
    
    NSNumber *listType = [JPUtils numberValueSafe:inquiry[@"listType"]];
    [cell setInquryType:[listType integerValue]];
    
    
//    cell.btnCancel.enabled = (status == kJPInquiryStatusWaitingQuatation);
//    cell.btnEdit.enabled = (status == kJPInquiryStatusWaitingQuatation);
    
    NSMutableArray *strings = [NSMutableArray array];
    if ([inquiry objectForKey:@"makeName"]) {
        [strings addObject:[inquiry objectForKey:@"makeName"]];
    }
    if ([inquiry objectForKey:@"carName"]) {
        [strings addObject:[inquiry objectForKey:@"carName"]];
    }
    if ([inquiry objectForKey:@"year"]) {
        [strings addObject:[inquiry objectForKey:@"year"]];
    }
    if ([inquiry objectForKey:@"modelName"]) {
        [strings addObject:[inquiry objectForKey:@"modelName"]];
    }
    cell.lblOfferName.text = [strings componentsJoinedByString:@" "];
    
    cell.lblShopName.text = [inquiry objectForKey:@"dealerName"];
    cell.lblShopPhone.text = [inquiry objectForKey:@"dealerPhone"];
    
    CGFloat timeStamp = [[inquiry objectForKey:@"updateTime"] longLongValue];
    cell.lblTime.text = [JPUtils timeStringFromStamp:timeStamp];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isDataSourceEmpty]) {
        return;
    }
    
    id inquiry = _inquiries[indexPath.row];
    
    UNPMyInquiryVC *vc = [UNPMyInquiryVC newFromStoryboard];
    vc.inquiry = inquiry;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - inquiry item cell delegate
//-(void)willOpenInquiryItemCell:(JPMyInquiryItemCell *)cell {
//    [self closeCellsExcept:cell];
//}
//
//-(void)didOpenInquiryItemCell:(JPMyInquiryItemCell *)cell {
//    
//}
//
//-(void)willCloseInquiryItemCell:(JPMyInquiryItemCell *)cell {
//    
//}
//
//-(void)didCloseInquiryItemCell:(JPMyInquiryItemCell *)cell {
//    
//}

-(void)inquiryItemCell:(JPMyInquiryItemCell *)cell cancelAtIndex:(NSInteger)index {
    
//    [self closeCellsExcept:nil];
    
    NSDictionary *inquiry = _inquiries[index];
    id inquiryID = [inquiry objectForKey:@"ID"];
    
    @weakify(self)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"撤消询价单" message:@"是否要撤消此询价单？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[self cancelInquirySignalWithID:inquiryID] subscribeNext:^(DymBaseRespModel *result) {
            
            @strongify(self)
            
            if ([result isKindOfClass:[DymBaseRespModel class]] && result.success) {
                [[JLToast makeTextQuick:@"撤消成功"] show];
                
                NSMutableDictionary *mutableInquiry = [inquiry mutableCopy];
                [mutableInquiry setObject:@(kJPInquiryStatusCancelled) forKey:@"status"];
                [_inquiries replaceObjectAtIndex:index withObject:mutableInquiry];
                
                [self.tableView reloadData];
            }
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)inquiryItemCell:(JPMyInquiryItemCell *)cell editAtIndex:(NSInteger)index {
    
    NSDictionary *inquiry = _inquiries[index];
    id inquiryID = [inquiry objectForKey:@"ID"];
    
    UNPCreateInquiryVC *vc = [UNPCreateInquiryVC newFromStoryboard];
    vc.inquiryID = inquiryID;
    
    DymNavigationController *nc = [[DymNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
    
//    [self closeCellsExcept:nil];
}

#pragma mark - scrollview delegate
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    
//    NSArray *visibleCells = [self.tableView visibleCells];
//    for (JPMyInquiryItemCell *theCell in visibleCells) {
//        if ([theCell isKindOfClass:[JPMyInquiryItemCell class]]) {
//            [theCell showRightButtons:NO];
//        }
//    }
//}
//
//-(void)closeCellsExcept:(JPMyInquiryItemCell *)cell {
//    NSArray *visibleCells = [self.tableView visibleCells];
//    for (JPMyInquiryItemCell *theCell in visibleCells) {
//        if (cell == nil || theCell != cell) {
//            if ([theCell isKindOfClass:[JPMyInquiryItemCell class]]) {
//                [theCell showRightButtons:NO];
//            }
//        }
//    }
//}

#pragma mark - requests

-(void)resetFilterAndRequestData {
    _apiInquiryList = [InquiryApi_InquiryList new];
    _apiInquiryList.listType = @(kJPInquiryTypeAll);
    _apiInquiryList.pageSize = @(pageSize);
    
    [self getFirstPage];
}

-(void)getFirstPageAndShowLoading {
    
    [self getFirstPage];
    [self.tableView setContentOffset:CGPointMake(0, -CGRectGetHeight(_refreshControl.frame)) animated:YES];
}

-(void)getFirstPage {
    _pageIndex = 1;
    _hasMore = YES;
    
    [self getInquiries];
    
    [_refreshControl beginRefreshing];
    self.tableView.showsInfiniteScrolling = NO;
}

-(void)getNextPage {
    if (_hasMore) {
        _pageIndex ++;
        [self getInquiries];
    }
}

-(void)getInquiries {
    @weakify(self)
    [[self getInquiriesSignal] subscribeNext:^(InquiryApi_InquiryList_Result *result) {
        
        @strongify(self)
        self->_hasRequestedInquiryList = YES;
        
        if ([result isKindOfClass:[InquiryApi_InquiryList_Result class]]) {
            
            if (self->_pageIndex <= 1) {
                [self->_inquiries removeAllObjects];
            }
            
            if (result.success) {
                
                [self->_inquiries addObjectsFromArray:result.list];
                
                if (result.list.count <= 0) {
                    _hasMore = NO;
                    self.tableView.showsInfiniteScrolling = NO;
                    
                    if (_pageIndex > 1) {
                        [[JLToast makeTextQuick:@"没有更多了"] show];
                    }
                    
                } else if (result.list.count > 0 && result.list.count < [_apiInquiryList.pageSize longLongValue]) {
                    // 如果返回的数据条数大于0但小于pageSize，就视为最后一页数据
                    _hasMore = NO;
                    self.tableView.showsInfiniteScrolling = NO;
                    
                } else {
                    _hasMore = YES;
                    self.tableView.showsInfiniteScrolling = YES;
                }
                
                [self->_refreshControl endRefreshing];
                [self.tableView.infiniteScrollingView stopAnimating];
                
            } else {
                self.tableView.showsInfiniteScrolling = NO;
                [self.tableView.infiniteScrollingView stopAnimating];
                [self->_refreshControl endRefreshing];
            }
            
            [self.tableView reloadData];
            
        } else {
            self.tableView.showsInfiniteScrolling = NO;
            [self.tableView.infiniteScrollingView stopAnimating];
            [self->_refreshControl endRefreshing];
        }
    }];
}

#pragma mark - signals
-(RACSignal *)cancelInquirySignalWithID:(NSNumber *)inquiryID {
    
    id param = @{@"inquiryid" : inquiryID ? : @0};
    
    return [DymRequest commonApiSignalWithClass:[InquiryApi_InquiryEditState class] queue:self.apiQueue params:param];
}

-(RACSignal *)getInquiriesSignal {
    
    _apiInquiryList.pageIndex = @(_pageIndex);
//    _apiInquiryList.organid = [JPAppStatus loginInfo].organID;
    
    return [DymRequest commonApiSignal:_apiInquiryList queue:self.apiQueue];
}

@end
