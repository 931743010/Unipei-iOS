//
//  UNPHomepageVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/16.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPHomepageVC.h"
#import <Masonry/Masonry.h>
#import "JPAppStatus.h"
#import <DYMRollingBanner/DYMRollingBannerVC.h>
#import "UIViewController+PSContainment.h"
#import "DymVerticalButton.h"
#import "JPUtils.h"
#import "JPDesignSpec.h"
#import "UNPDeveloperVC.h"
#import "JPSensibleButton.h"
#import "UNPMessageCenterVC.h"
#import "JPRedDotView.h"
#import <UnipeiApp-Swift.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NoticeVC.h"

#import "UNP4sQueryVC.h"


@interface UNPHomepageVC () {
    UITableViewCell     *_headerCell;
    UITableViewCell     *_menuCell;
    
    DymVerticalButton   *_btnInquiry;
    DymVerticalButton   *_btnDealer;
    DymVerticalButton   *_btn4S;
    
    UIView              *_viewHeaderNews;
    DYMRollingBannerVC  *_rollingBannerVC;
    
    JPRedDotView        *_messageDot;
    
    NSArray             *_activityPicList;
    NSArray             *_rollingImages;
    NSArray             *_noticeData;
}

@end

@implementation UNPHomepageVC

- (void)viewDidLoad {
    
    @weakify(self)
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1];
    
    self.navigationItem.title = @"由你配";
    
#if DEBUG
    UIBarButtonItem *btnServer = [[UIBarButtonItem alloc] initWithTitle:@"服" style:UIBarButtonItemStylePlain target:nil action:nil];
    btnServer.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSString *serverStr = [JPServerApiURL descriptionForEnv:[JPServerApiURL serverEnv]];
        NSString *userStr = [NSString stringWithFormat:@"用户名:%@\n密码:%@", [JPAppStatus loginInfo].loginUsername, [JPAppStatus loginInfo].loginPassword];
        NSString *message = [NSString stringWithFormat:@"<服务器环境>\n%@\n            \n%@", serverStr, userStr];
        [SVProgressHUD showInfoWithStatus:message];
        
        return [RACSignal empty];
    }];
    
    
    UIBarButtonItem *btnLogout = [[UIBarButtonItem alloc] initWithTitle:@" 退" style:UIBarButtonItemStylePlain target:nil action:nil];
    btnLogout.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        [JPAppStatus logout];
        
        return [RACSignal empty];
    }];
    
    UIBarButtonItem *btnDev = [[UIBarButtonItem alloc] initWithTitle:@"发 " style:UIBarButtonItemStylePlain target:nil action:nil];
    btnDev.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        UNPDeveloperVC *vc = [UNPDeveloperVC new];
        @strongify(self)
        [self.navigationController pushViewController:vc animated:YES];
        
        return [RACSignal empty];
    }];
    
    self.navigationItem.leftBarButtonItems = @[btnDev, btnServer, btnLogout];
#endif
    
    JPSensibleButton *btnMessages = [[JPSensibleButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [btnMessages setImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    [[btnMessages rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self)
        //        [self closeCellsExcept:nil];
        UNPMessageCenterVC *vc = [UNPMessageCenterVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    _messageDot = [JPRedDotView new];
    _messageDot.radius = 3;
    _messageDot.offset = CGPointMake(4, -4);
    [_messageDot installTo:btnMessages];
    [self updateRedDot];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnMessages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRedDot) name:JP_NOTIFICATION_NEW_MESSAGE_STATE_CHANGED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRollingBanners) name:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotiveData) name:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
    
//    [self refreshRollingBanners];
}

#pragma mark - 获取公告数据
-(void)getNotiveData{
    
    @weakify(self)
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_commonApi_getPapSysnoticeList;
    api.apiVersion = @"V2.2";
    api.custom_organIdKey = @"organID";

    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        
        @strongify(self)
        if (result.success) {
            
            _noticeData = result.body[@"list"];
            NSLog(@">>>>>>fuck you data%@<<<<<<<",_noticeData);
            [self.tableView reloadData];
        }
        
    }];
    
}
-(void)refreshRollingBanners {
    
//#pragma note - this code is for debug...
//    BOOL showServerList = [JPAppStatus showServerList];
//    if (showServerList) {
//        [SVProgressHUD showInfoWithStatus:@"开始获取轮播图"];
//    }
    
    
    @weakify(self)
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = @"commonApi/findActivityPicList.do";
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        @strongify(self)
        
        _rollingImages = nil;
        if (result.success) {
            
            _activityPicList = result.body[@"activityPicList"];
            
            NSMutableArray *rollingImages = [NSMutableArray array];
            [_activityPicList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj[@"url"]) {
                    [rollingImages addObject:obj[@"url"]];
                }
            }];
            
            _rollingImages = rollingImages;
        }
        
        [self.tableView reloadData];
        
        
//#pragma note - this code is for debug...
//        if (showServerList) {
//            NSString *message = [NSString stringWithFormat:@"UnionID:%@\n [findActivityPicList]%@", [JPAppStatus loginInfo].unionID, result.body];
//            [SVProgressHUD showInfoWithStatus:message];
//        }
        
    
    }];
}

-(void)updateRedDot {
    _messageDot.hidden = ![JPAppStatus hasNewMessage];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return self.view.frame.size.width * 0.5625; // 16:9
        
    } else if (indexPath.section == 1) {
        
        return 110;
    }
    
    return 48;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        if (_noticeData.count == 0) {
            return 1;
        }
        return _noticeData.count;
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (_headerCell == nil) {
            _headerCell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
            _headerCell.backgroundColor = [JPDesignSpec colorGrayDark];
            _headerCell.contentView.backgroundColor = [JPDesignSpec colorGrayDark];
            
            _rollingBannerVC = [DYMRollingBannerVC new];
            _rollingBannerVC.view.backgroundColor = [JPDesignSpec colorGrayDark];
            _rollingBannerVC.placeHolder = [UIImage imageNamed:@"default_banner"];
            _rollingBannerVC.rollingInterval = 10;
            
            
//            _rollingBannerVC.rollingImages = @[[UIImage imageNamed:@"rolling_banner_1"]
//                                    , [UIImage imageNamed:@"rolling_banner_2"]
////                                    , @"http://epaper.syd.com.cn/sywb/res/1/20080108/42241199752656275.jpg"
//                                    ];
            
            [_rollingBannerVC addBannerTapHandler:^(NSInteger whichIndex) {
//                NSLog(@"banner tapped, index = %@", @(whichIndex));
            }];
            
            // Install it
            [self installChildVC:_rollingBannerVC toContainerView:_headerCell.contentView];
        }
        
        _rollingBannerVC.rollingImages = _rollingImages;
        
        if (_rollingImages.count > 0) {
            [_rollingBannerVC startRolling];
        } else {
            [_rollingBannerVC stopRolling];
        }
        
        return _headerCell;
        
    } else if (indexPath.section == 1) {
        
        if (_menuCell == nil) {
            _menuCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
            
            _btnInquiry = (DymVerticalButton *)[_menuCell.contentView viewWithTag:100];
            _btnDealer = (DymVerticalButton *)[_menuCell.contentView viewWithTag:101];
            _btn4S = (DymVerticalButton *)[_menuCell.contentView viewWithTag:102];
            
            [@[_btnInquiry, _btnDealer, _btn4S] enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
                obj.backgroundColor = [UIColor clearColor];
            }];
            
            _btnInquiry.ivLogo.image = [UIImage imageNamed:@"icon_home_inquiry"];
            _btnDealer.ivLogo.image = [UIImage imageNamed:@"icon_home_dealer"];
            _btn4S.ivLogo.image = [UIImage imageNamed:@"home_btn_4s"];
            
            _btnInquiry.lblTitle.text = @"询报价";
            _btnDealer.lblTitle.text = @"经销商";
            _btn4S.lblTitle.text = @"4S报价";
            
//            _btnDealer.lblTitle.textColor = [JPDesignSpec colorGray];
            _btn4S.lblTitle.textColor = [JPDesignSpec colorGray];
            
            [JPUtils installRightLine:_btnInquiry color:[UIColor colorWithWhite:0.85 alpha:1] insets:UIEdgeInsetsMake(20, 0, 20, 0)];
            [JPUtils installRightLine:_btnDealer color:[UIColor colorWithWhite:0.85 alpha:1] insets:UIEdgeInsetsMake(20, 0, 20, 0)];
            
            [[_btnInquiry rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                self.tabBarController.selectedIndex = 1;
            }];
            
            [[_btnDealer rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                self.tabBarController.selectedIndex = 2;
                
            }];
            
            [[_btn4S rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                UNP4sQueryVC *vc = [UNP4sQueryVC newFromStoryboard];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }
        
        return _menuCell;
        
    } else if (indexPath.section == 2) {
        
//  {"id": 2,  "imgUrl": "servicer/images/notices/201512221137057608.png",  "createTime": 1450688400,   "title": "test1",  "updateTime": 0, "digest": "test1"   "url": "http://www.dev.jiaparts.com/2"},
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsItemCell" forIndexPath:indexPath];
            
        UILabel *lblMessage = (UILabel *)([cell.contentView viewWithTag:100]);
        
        UILabel *lblTime = (UILabel *)([cell.contentView viewWithTag:101]);
        
        UIImageView *ivIsNew = (UIImageView *)[cell.contentView viewWithTag:102];
        
        if (_noticeData.count == 0) {
            
            lblMessage.text = @"暂无公告";
            lblTime.text = nil;
            
        }else{
            BOOL isTop = [_noticeData[indexPath.row][@"isTop"] boolValue];
            if (isTop) {
                ivIsNew.hidden = NO;
            }
            //TODO 判断ivIsnew是否显示
            lblMessage.text = [NSString stringWithFormat:@"%@",_noticeData[indexPath.row][@"title"]];
            
            CGFloat ff = [_noticeData[indexPath.row][@"createTime"] doubleValue];
            lblTime.text = [JPUtils dateStringFromStamp:ff];

        }
        
        return cell;
    }
    
    return [UITableViewCell new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        if (_viewHeaderNews == nil) {
            _viewHeaderNews = [UIView new];
            _viewHeaderNews.backgroundColor = [JPDesignSpec colorSilver];
            UILabel *lbl = [UILabel new];
            lbl.textColor = [UIColor colorWithWhite:0 alpha:0.87];
            lbl.font = [UIFont systemFontOfSize:14];
            lbl.text = @"公告";
            [_viewHeaderNews addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_viewHeaderNews.mas_centerY);
                make.leading.equalTo(_viewHeaderNews.mas_leading).offset(16);
            }];
        }
        
        return _viewHeaderNews;
    }
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 32;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        
        if (_noticeData.count > 0) {
            
            NoticeVC *vc = [[NoticeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.dataDic = _noticeData[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            
        }

//        [[JLToast makeTextQuick:@"公告系统正在完善中"] show];
    }
}



@end
