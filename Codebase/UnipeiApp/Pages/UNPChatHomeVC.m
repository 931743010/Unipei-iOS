//
//  UNPChatHomeVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChatHomeVC.h"
#import <Masonry/Masonry.h>
#import "MineBigCell.h"
#import "MineCommonCell.h"
#import "MineLblCell.h"
#import "SettingPushVC.h"
#import "MyOrderVC.h"
#import "UNPAddressManageVC.h"
#import "UNPMessageCenterVC.h"
#import "UNPPersonalInformationVC.h"
#import "JPDesignSpec.h"
#import "JPAppStatus.h"
#import "JPRedDotView.h"
#import "CouponVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>

#define AVATAR_RADIUS               (32)
#define TABLE_HEADER_BASE_HEIGHT    (96)

@interface UNPChatHomeVC ()<UITableViewDataSource, UITableViewDelegate
, MineBigCellDelegate>
{
    UITableView *_table;
    UIImageView *_headImg;
    UILabel *_name;
    UILabel *_venderName;
    NSArray *_imageArr;
    NSArray *_titleArr;
    
    MineBigCell *_cellFourButtons;
    
    UIView          *_tableHeaderView;
    
    MASConstraint   *_constraintHeaderTop;
    MASConstraint   *_constraintHeaderHeight;
    
    UILabel             *_lblNewMessageTipView;
    JPRedDotView        *_messageDot;
}

@end

@implementation UNPChatHomeVC

#pragma mark - photo browser
//-(void)showAvatar {
//    
//    if ([JPAppStatus loginInfo].logo.length <= 0) {
//        return;
//    }
//    
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = NO;
//    browser.zoomPhotosToFill = YES;
//    browser.enableGrid = NO;
//    browser.autoPlayOnAppear = NO;
//    
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
//    [[JPUtils topMostVC] presentViewController:nc animated:YES completion:nil];
//}
//
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    return 1;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    NSString *imageURL = [JPUtils fullMediaPath:[JPAppStatus loginInfo].logo];
//    return [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imageURL]];
//}

#pragma mark - view lifecycle
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /// fill data
    NSString *imageURL = [JPUtils fullMediaPath:[JPAppStatus loginInfo].logo];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"icon_logo_white"]];
    _name.text = [JPAppStatus loginInfo].loginUsername;
    _venderName.text = [JPAppStatus loginInfo].organName;
    
    [self updateOrderStatusCount];
}


//-(void)viewWillDisappear:(BOOL)animated {
//    
//    [super viewWillDisappear:animated];
//    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageArr = @[@[@"1-4",@"2-1",@"2-4"],@[@"1-8"]];
    _titleArr = @[@[@"管理收货地址",@"消息中心",@"优惠劵"],@[@"设置"]];
    
    self.navigationItem.title = @"个人中心";
    
    
    _lblNewMessageTipView = [UILabel new];
    _lblNewMessageTipView.textColor = [JPDesignSpec colorGray];
    _lblNewMessageTipView.font = [JPDesignSpec fontSub];
    _lblNewMessageTipView.text = @"您有一条新消息";
    _messageDot = [JPRedDotView new];
    _messageDot.radius = 3;
    _messageDot.offset = CGPointMake(4, -4);
    [_messageDot installTo:_lblNewMessageTipView];
    
    _tableHeaderView = [UIView new];
    _tableHeaderView.backgroundColor = [JPDesignSpec colorMajor];
    
//    添加push手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPush)];
    [_tableHeaderView addGestureRecognizer:tap];

    
    //
    _headImg = [UIImageView new];
    _headImg.contentMode = UIViewContentModeScaleAspectFill;
    _headImg.userInteractionEnabled = YES;
//    [_headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAvatar)]];
    _headImg.clipsToBounds = YES;
    [_headImg.layer setCornerRadius:AVATAR_RADIUS];
    [_tableHeaderView addSubview:_headImg];
    [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(_tableHeaderView.mas_centerY).offset(0);
        make.left.equalTo(_tableHeaderView.mas_left).with.offset(16);
        make.height.mas_equalTo(@(AVATAR_RADIUS * 2));
        make.width.mas_equalTo(@(AVATAR_RADIUS * 2));
        
    }];
    
    _name = [UILabel new];
    [_name setFont:[UIFont systemFontOfSize:14]];
    [_name setTextColor:[UIColor whiteColor]];
    [_tableHeaderView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_headImg.mas_right).with.offset(16);
        make.top.equalTo(_headImg.mas_top).offset(5);
        make.height.mas_equalTo(@20);
        
    }];
    
    _venderName = [UILabel new];
    _venderName.numberOfLines = 2;
    [_venderName setFont:[UIFont systemFontOfSize:12]];
    [_venderName setTextColor:[UIColor whiteColor]];
    [_tableHeaderView addSubview:_venderName];
    [_venderName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_headImg.mas_right).with.offset(16);
        make.top.equalTo(_name.mas_bottom).with.offset(14);
        make.trailing.equalTo(_tableHeaderView.mas_trailing).with.offset(-16);
        
    }];
    
    
    //初始化tableview
    _table = [UITableView new];
    [_table registerClass:[MineCommonCell class] forCellReuseIdentifier:@"MineCommonCell"];
    _table.backgroundColor = [UIColor clearColor];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setDataSource:self];
    [_table setDelegate:self];
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _table.bounces = NO;
    /// 头部效果
    [_table addSubview:_tableHeaderView];
    [_tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_table);
        make.width.equalTo(_table.mas_width);
        _constraintHeaderTop = make.top.equalTo(_table.mas_top).offset(-TABLE_HEADER_BASE_HEIGHT);
        _constraintHeaderHeight = make.height.equalTo(@(TABLE_HEADER_BASE_HEIGHT));
    }];
    _table.contentInset = UIEdgeInsetsMake(TABLE_HEADER_BASE_HEIGHT, 0, 0, 0);
    _table.contentOffset = CGPointMake(0, -TABLE_HEADER_BASE_HEIGHT);
    
    ///
    @weakify(self)
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:JP_NOTIFICATION_USER_LOGGED_IN object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        [self updateOrderStatusCount];
    }];
    [self.observerQueue addObject:observer];
    
//    [self updateOrderStatusCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderStatusCount) name:JP_NOTIFICATION_NEW_MESSAGE_STATE_CHANGED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderStatusCount) name:JP_NOTIFICATION_INQUIRY_CHANGED object:nil];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRedDot) name:JP_NOTIFICATION_NEW_MESSAGE_STATE_CHANGED object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateRedDot];
    });
}



-(void)updateRedDot {
    _lblNewMessageTipView.hidden = ![JPAppStatus hasNewMessage];
    [_table reloadData];
}

#pragma mark 私有方法
-(void)tapToPush{
    
    UNPPersonalInformationVC *vc = [[UNPPersonalInformationVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"%f--------",offsetY);
    if (offsetY < -TABLE_HEADER_BASE_HEIGHT) {
        _constraintHeaderTop.offset = offsetY;
        _constraintHeaderHeight.offset = - offsetY;
    }
}


#pragma mark - UITableViewDatasource and Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return 1;
        
    }else if (section == 1){
        return 3;
    }
    return 2;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        return 72;
        
    }
    return 48;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            MineLblCell *cell = [[MineLblCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (indexPath.row == 1){
            if (_cellFourButtons == nil) {
                _cellFourButtons = [[MineBigCell alloc] init];
                _cellFourButtons.delegate = self;
                _cellFourButtons.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return _cellFourButtons;
            
        }
    }
    
    MineCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCommonCell" forIndexPath:indexPath];
    
    cell.img.image = [UIImage imageNamed:[[_imageArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row]];
    cell.lbl.text = [[_titleArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 1 && indexPath.row == 1) { //消息中心
        [cell.contentView addSubview:_lblNewMessageTipView];
        [_lblNewMessageTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(cell.contentView.mas_trailing).offset(-35);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        MyOrderVC *vc = [[MyOrderVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1){
    
        if (indexPath.row == 0) { // 管理收货地址
            
            UNPAddressManageVC *vc = [UNPAddressManageVC newFromStoryboard];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 1) { // 消息中心
            
            UNPMessageCenterVC *vc = [[UNPMessageCenterVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){ //优惠劵
            CouponVC *coupon = [[CouponVC alloc]init];
            coupon.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:coupon animated:YES];
        
        }
    
    }else if (indexPath.section == 2){
    
        SettingPushVC *vc = [SettingPushVC newFromStoryboard];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
//    header.backgroundColor = [JPDesignSpec colorSilver];
    return header;
}

-(void)selectBtn:(NSInteger)currentIndex{
    
    MyOrderVC *vc = [[MyOrderVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.orderStatus = @(currentIndex);
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)updateOrderStatusCount {
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_orderApi_orderStatusCount;
    api.custom_organIdKey = @"organID";
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        
        if (result.success) {
            
//            {"alerCancelCount":0,"toBeGoodsReceiptCount":0,"alrConfirmCount":0,"toBeShippedCount":39}
//            @[@(kJPOrderStatusWaitingForShipping), @(kJPOrderStatusWaitingForReceival), @(kJPOrderStatusReceived), @(kJPOrderStatusCancelled)];
            
            NSInteger cancelCount = [result.body[@"alerCancelCount"] integerValue];
            NSInteger waitShipCount = [result.body[@"toBeShippedCount"] integerValue];
            NSInteger waitReceiveCount = [result.body[@"toBeGoodsReceiptCount"] integerValue];
            NSInteger receivedCount = [result.body[@"alrConfirmCount"] integerValue];
            
            [_cellFourButtons setBadgeNumber:cancelCount forValue:kJPOrderStatusCancelled];
            [_cellFourButtons setBadgeNumber:waitShipCount forValue:kJPOrderStatusWaitingForShipping];
            [_cellFourButtons setBadgeNumber:waitReceiveCount forValue:kJPOrderStatusWaitingForReceival];
            [_cellFourButtons setBadgeNumber:receivedCount forValue:kJPOrderStatusReceived];
        }
    }];
}

@end
