//
//  MyOrderVC.m
//  DymIOSApp
//
//  Created by xujun on 15/10/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//
#define PageSize 20
//#define BtnOneTag 100
//#define BtnTwoTag 1000

#import "MyOrderVC.h"
#import "UNPOrderItemDoubleCell.h"
#import "UNPOrderItemCell.h"
#import <Masonry/Masonry.h>
#import "OrderApi_OrderList.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyOrderFilterVC.h"
#import "JPSidePopVC.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <UnipeiApp-Swift.h>
#import "UNPOrderDetailVC.h"
#import "UNPOrderTrackVC.h"
#import "JPGuessMyKey.h"
#import "JPUtils.h"

@interface MyOrderVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSMutableArray *_orderList;
    //    NSMutableArray *btnArrayOne;
    CGFloat _page;
    BOOL _hasMore;
    OrderApi_OrderList *_apiOrderList;
    UIRefreshControl *_refreshControl;
    BOOL _hasRequestedOrderList;
    
}
@property (nonatomic,assign) int count;
@end

@implementation MyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _hasMore = YES;
    
    @weakify(self)
    //    btnArrayOne = [NSMutableArray array];
    _orderList = [NSMutableArray arrayWithCapacity:PageSize];
    
    self.navigationItem.title = @"我的订单";
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setFrame:CGRectMake(0, 0, 24, 24)];
    [rightBtn setImage:[UIImage imageNamed:@"btn_filter"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    _table = [UITableView new];
    _table.backgroundColor = [UIColor clearColor];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view);
        
    }];
    
    // 上下拉刷新
    _refreshControl = [[UIRefreshControl alloc] init];
    [_table addSubview:_refreshControl];
    [[_refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self getFirstPage];
    }];
    
    [_table addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [self getNextPage];
    }];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFirstPageAndShowLoading) name:JP_NOTIFICATION_INQUIRY_FILTER_CHANGED object:nil];
    
    //注册cell
    [_table registerClass:[UNPOrderItemCell class] forCellReuseIdentifier:@"UNPOrderItemCell"];
    
    [_table registerClass:[UNPOrderItemDoubleCell class] forCellReuseIdentifier:@"UNPOrderItemDoubleCell"];
    
    [self resetFilterAndRequestData];
    [_refreshControl beginRefreshing];
    
}
#pragma mark - actions
-(void)getFirstPageAndShowLoading {
    
    [self getFirstPage];
    [_table setContentOffset:CGPointMake(0, -CGRectGetHeight(_refreshControl.frame)) animated:YES];
}

-(void)resetFilterAndRequestData {
    _apiOrderList = [OrderApi_OrderList new];
    
    if (_orderStatus == nil) {
        _apiOrderList.status = @(kJPOrderStatusAll);
    }else{
        _apiOrderList.status = _orderStatus;
        _orderStatus = nil;
    }
    _apiOrderList.pageSize = @(PageSize);
    
    [self getFirstPage];
}

-(void)getFirstPage {
    _page = 1;
    _hasMore = YES;
    
    [self getInquiries];
    
    [_refreshControl beginRefreshing];
    _table.showsInfiniteScrolling = NO;
}

-(void)getNextPage {
    if (_hasMore) {
        _page ++;
        [self getInquiries];
    }
}
-(void)getInquiries {
    @weakify(self)
    [[self getInquiriesSignal] subscribeNext:^(OrderApi_OrderList_Result *result) {
        
        @strongify(self)
        self->_hasRequestedOrderList = YES;
        
        if ([result isKindOfClass:[OrderApi_OrderList_Result class]]) {
            
            if (self->_page <= 1) {
                [self->_orderList removeAllObjects];
            }
            
            if (result.success) {
                
                /// 将oder改为mutable
                NSMutableArray *mutableOrders = [NSMutableArray array];
                [result.orderList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        [mutableOrders addObject:[obj mutableCopy]];
                    }
                }];
                
                [self->_orderList addObjectsFromArray:mutableOrders];
                
                if (mutableOrders.count <= 0) {
                    self->_hasMore = NO;
                    self->_table.showsInfiniteScrolling = NO;
                    
                    if (self->_page > 1) {
                        [[JLToast makeTextQuick:@"没有更多了"] show];
                    }
                    
                } else if (mutableOrders.count > 0 && mutableOrders.count < [self->_apiOrderList.pageSize longLongValue]) {
                    // 如果返回的数据条数大于0但小于pageSize，就视为最后一页数据
                    self->_hasMore = NO;
                    self->_table.showsInfiniteScrolling = NO;
                    
                } else {
                    self->_hasMore = YES;
                    self->_table.showsInfiniteScrolling = YES;
                }
                
                [self->_refreshControl endRefreshing];
                [self->_table.infiniteScrollingView stopAnimating];
                
            } else {
                self->_table.showsInfiniteScrolling = NO;
                [self->_table.infiniteScrollingView stopAnimating];
                [self->_refreshControl endRefreshing];
            }
            
            [self->_table reloadData];
            
        } else {
            self->_table.showsInfiniteScrolling = NO;
            [self->_table.infiniteScrollingView stopAnimating];
            [self->_refreshControl endRefreshing];
        }
        
        [self showEmptyView:(self->_orderList.count <= 0) text:@"暂无订单数据"];
    }];
}
-(RACSignal *)getInquiriesSignal {
    
    _apiOrderList.page = @(_page);
    //    _apiInquiryList.organid = [JPAppStatus loginInfo].organID;
    
    return [DymRequest commonApiSignal:_apiOrderList queue:self.apiQueue];
}

//导航栏右边按钮
-(void)rightBtnAction : (id) sender{
    
    MyOrderFilterVC *vc = [[MyOrderFilterVC alloc] init];
    vc.filterData = _apiOrderList;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[JPSidePopVC new] showVC:nav];
    
}
#pragma mark - UITableViewDatasource and Delegate
-(BOOL)isDataSourceEmpty {
    return _hasRequestedOrderList && _orderList.count <= 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%lu",(unsigned long)_orderList.count);
    return _orderList.count;
    //    return self.count;
    
}
//cell的高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *goodlist = [[_orderList objectAtIndex:indexPath.row] objectForKey:@"goodsList"];
    
    if (goodlist.count == 1) {
        
        return 208;
        
    }else if (goodlist.count == 2){
        
        return 272;
        
    }return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *order = [_orderList objectAtIndex:indexPath.row];
    NSArray *goodlist = [order objectForKey:@"goodsList"];
    
    ////////  创建一个继承于UNPOrderItemCell的空cell实例
    UNPOrderItemCell *cell;
    //根据数据判断cell类型
    if (goodlist.count == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UNPOrderItemCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UNPOrderItemDoubleCell" forIndexPath:indexPath];
    }
    
    
    //    给每个cell上的btnOne设置tag值
    cell.btnOne.tag = indexPath.row;
    [cell.btnOne removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell.btnOne addTarget:self action:@selector(btnOneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnTwo.tag = indexPath.row;
    [cell.btnTwo removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell.btnTwo addTarget:self action:@selector(btnTwoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self updateCancelButtonStatus:cell.btnTwo];
    
    //填充数据
    cell.venderName.text = [order objectForKey:@"SellerName"];
    
//    cell.statusLbl.text = [order objectForKey:@"statusName"];
    NSString *status = [order objectForKey:@"statusName"];
    NSString *statusAdd = order[@"statusAddName"];
    if ([statusAdd isKindOfClass:[NSString class]] && statusAdd.length > 0) {
        status = [status stringByAppendingFormat:@"(%@)", statusAdd];
    }
    cell.statusLbl.text = status;
    
    //判断数据是否为空，若不为空则加载数据
    NSArray *img = [[goodlist objectAtIndex:0] objectForKey:@"img"];
    if (img.count > 0 && [img objectAtIndex:0]!= [NSNull null]) {
        
        [self loadImage:[[[[goodlist objectAtIndex:0] objectForKey:@"img"] objectAtIndex:0] objectForKey:@"imageurl"] :cell.image];
        
    } else {
        [self loadImage:nil :cell.image];
    }
    
    
    cell.nameLbl.text = [[goodlist objectAtIndex:0] objectForKey:@"GoodsName"];
    
    cell.introduce.text = [NSString stringWithFormat:@"档次:%@",[JPUtils stringValueSafe:[[goodlist objectAtIndex:0] objectForKey:@"partsLevelName"]]];
    
    cell.price.text = [NSString stringWithFormat:@"￥%.2f",[[[goodlist objectAtIndex:0] objectForKey:@"ProPrice"] floatValue]];
    
    cell.num.text = [NSString stringWithFormat:@"x%@",[[goodlist objectAtIndex:0] objectForKey:@"Quantity"]];
    
//    cell.totalprice.text = [NSString stringWithFormat:@"￥%.2f",[[order objectForKey:@"TotalAmount"] floatValue]];
    cell.totaltext.text = [NSString stringWithFormat:@"共计%ld件商品 实付款:", (long)[order[@"goodsCount"] integerValue]];
    cell.totalprice.text = [NSString stringWithFormat:@"￥%.2f",[[order objectForKey:@"TotalAmount"] doubleValue]];
    
    ///将相同的部分取出来放到外面后判断cell是否为UNPOrderItemDoubleCell并给cell填充数据
    if ([cell isKindOfClass:[UNPOrderItemDoubleCell class]]) {
        //重新实例化一个继承于上面cell但其类型为UNPOrderItemDoubleCell的空cell
        UNPOrderItemDoubleCell *doubleCell = (UNPOrderItemDoubleCell *)cell;
        
        doubleCell.lineLtwoTopConstraint.offset = 68;
        
        NSArray *imgTwo = [[goodlist objectAtIndex:1] objectForKey:@"img"];
        if (imgTwo.count > 0 && [imgTwo objectAtIndex:0]!=[NSNull null]) {
            [self loadImage:[[imgTwo objectAtIndex:0] objectForKey:@"imageurl"] :doubleCell.imgtwo];
        } else {
            [self loadImage:nil :doubleCell.imgtwo];
        }
        
        doubleCell.nameLbltwo.text = [[goodlist objectAtIndex:1] objectForKey:@"GoodsName"];
        
        doubleCell.introducetwo.text = [NSString stringWithFormat:@"档次:%@",[JPUtils stringValueSafe:[[goodlist objectAtIndex:1] objectForKey:@"partsLevelName"]]];
        
        doubleCell.pricetwo.text = [NSString stringWithFormat:@"￥%.2f", [[[goodlist objectAtIndex:1] objectForKey:@"ProPrice"] doubleValue]];
        
        doubleCell.numtwo.text = [NSString stringWithFormat:@"x%@",[[goodlist objectAtIndex:1] objectForKey:@"Quantity"]];
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id order = _orderList[indexPath.row];
    
    UNPOrderDetailVC *vc = [UNPOrderDetailVC newFromStoryboard];
    vc.orderID = order[@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}
//获取图片方法
-(void)loadImage:(NSString *)imgUrl :(UIImageView *)img{
    
    NSString *urlStr = imgUrl ? [JPUtils fullMediaPath:imgUrl] : nil;
    
    [img sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_goods_logo_default"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
}

#pragma mark -
//订单跟踪按钮事件
-(void)btnOneAction:(UIButton *)btn{
    
    id order = _orderList[btn.tag];
    if ([order[@"ID"] longLongValue] > 0) {
        UNPOrderTrackVC *vc = [UNPOrderTrackVC newFromStoryboard];
        vc.orderID = order[@"ID"];
        vc.orderSN = order[@"OrderSN"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

//取消订单按钮事件
-(void)btnTwoAction:(UIButton *)btn{
    
    id order = _orderList[btn.tag];
    BOOL canCancel = [JPUtils canCancelOrder:order];
    NSString *title = canCancel ? @"是否取消此订单？" : @"是否确认收货？";
    
    @weakify(self)
    UIAlertController *vc = [JPUtils alert:title message:nil comfirmBlock:^(UIAlertAction *action) {
        
        @strongify(self)
        NSNumber *orderID = order[@"ID"];
        if ([orderID longLongValue] > 0) {
            
            DymCommonApi *api = [DymCommonApi new];
            api.relativePath = canCancel ? PATH_orderApi_orderCancel : PATH_orderApi_orderConfirm;
            api.params = @{@"orderID": orderID};
            api.custom_organIdKey = @"organID";
            
            @weakify(self)
            [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
                if (result.success) {
                    @strongify(self)
                    id status = @(canCancel ? kJPOrderStatusCancelled : kJPOrderStatusReceived);
                    [JPUtils setValue:status object:order possibleKeys:[JPGuessMyKey keys_status]];
                    [self updateCancelButtonStatus:btn];
                }
            }];
        }
        
    } cancelBlock:^(UIAlertAction *action) {
        
    }];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)updateCancelButtonStatus:(UIButton *)cancelButton {
    id order = _orderList[cancelButton.tag];
    BOOL canCancel = [JPUtils canCancelOrder:order];
    BOOL canConfirm = [JPUtils canConfirmOrder:order];
    BOOL needHideCancelButton = !canCancel && !canConfirm;
    
    id status = [JPUtils valueFromObject:order possibleKeys:[JPGuessMyKey keys_status]];
    NSString *nameForStatus = [JPUtils nameOfOrderStatus:[status integerValue]];
    
    UITableViewCell *cell = (UITableViewCell *)cancelButton.superview;
    if ([cell isKindOfClass:[UNPOrderItemCell class]]) {
        UNPOrderItemCell *cell2 = ((UNPOrderItemCell *)cell);
        [cell2 showCancelButton:!needHideCancelButton];
        cell2.statusLbl.text = nameForStatus;
    } else if ([cell isKindOfClass:[UNPOrderItemDoubleCell class]]) {
        UNPOrderItemDoubleCell *cell2 = ((UNPOrderItemDoubleCell *)cell);
        [cell2 showCancelButton:!needHideCancelButton];
        cell2.statusLbl.text = nameForStatus;
    }
    
    if (canCancel) {
        [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    } else if (canConfirm) {
        [cancelButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }
}


@end
