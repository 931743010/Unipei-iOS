//
//  UNPMessageCenterVC.m
//  DymIOSApp
//
//  Created by xujun on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPMessageCenterVC.h"
#import "UNPMessageClassifyCell.h"
#import "UNPSystemMessageVC.h"
#import "UNPBusinessMessageVC.h"
#import "JPUtils.h"
#import "JPDesignSpec.h"
#import "JPAppStatus.h"
#import "JPRedDotView.h"

@interface UNPMessageCenterVC ()
{
    NSArray          *_titleArray;
    NSArray          *_subTitleArr;
    NSArray          *_imageNameArr;
    NSArray          *_logos;

    id                  _lastRemindInfo;
    
    JPRedDotView        *_messageDotSystem;
    JPRedDotView        *_messageDotBusiness;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UNPMessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息中心";
    
    _titleArray = @[@"系统消息",@"业务消息"];
    _logos = @[[UIImage imageNamed:@"icon_message_sys"], [UIImage imageNamed:@"icon_message_bus"]];
    _imageNameArr = @[@"",@""];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 76;
    UINib *nib = [UINib nibWithNibName:@"UNPMessageClassifyCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"UNPMessageClassifyCell"];
    
    // 如果进入这个页面，就消掉message红点
    [JPAppStatus setHasNewMessage:NO];
    
    //
    _messageDotSystem = [JPRedDotView new];
    _messageDotSystem.radius = 3;
    _messageDotSystem.offset = CGPointMake(4, -4);
    
    _messageDotBusiness = [JPRedDotView new];
    _messageDotBusiness.radius = 3;
    _messageDotBusiness.offset = CGPointMake(4, -4);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRedDot) name:JP_NOTIFICATION_NEW_MESSAGE_STATE_CHANGED object:nil];
    [self updateRedDot];
}

-(void)updateRedDot {
    _messageDotSystem.hidden = ![JPAppStatus hasNewSystemMessage];
    _messageDotBusiness.hidden = ![JPAppStatus hasNewBusinessMessage];
    
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getAllMessageData];
}

-(void)getAllMessageData{
    
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_remindApi_queryLastRemind;
//    api.params = @{@"remindID":@"",@"userID":@""};
    api.custom_organIdKey = @"organID";
    
    [self showLoadingView:YES];
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        [self showLoadingView:NO];
        if (result.success) {
            
            _lastRemindInfo = result.body;
//            _systemData = result.body[@"system"];
//            _businessData = result.body[@"business"];
            [_tableView reloadData];
        }
    }];
    
}
#pragma mark - UITableViewDatasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UNPMessageClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPMessageClassifyCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    cell.imageView.image = [UIImage imageNamed:_imageNameArr[indexPath.row]];
    cell.lblTitle.text = _titleArray[indexPath.row];
    cell.ivLogo.image = _logos[indexPath.row];
    
    cell.lblSubTitle.text = @"";
    cell.lblTime.text = @"";
    
    //"body":{"system":{"id":180,"content":"askasdhakj","organType":3,"createTime":"2015-11-20 17:49","readStatus":1,"linkUrl":"http://baidu.com","method":"","type":0,"organID":174585,"readerID":174585,"promoterID":18},"business":""}
    
    //根据获取到的数据判断是否有新消息决定lblSubTitle的text显示
    if (indexPath.row == 0) {
        id systemData = _lastRemindInfo[@"system"];
        if ([systemData isKindOfClass:[NSDictionary class]]) {
            
            cell.lblSubTitle.text = systemData[@"content"];
            cell.lblTime.text = systemData[@"createTime"];
//            BOOL notRead = [systemData[@"readStatus"] integerValue] == 0;
            
        } else {
            cell.lblSubTitle.text = @"暂无新的消息";
        }
        
        [_messageDotSystem installTo:cell.ivLogo];
        
    } else if (indexPath.row == 1) {
        
        id businessData = _lastRemindInfo[@"business"];
        if ([businessData isKindOfClass:[NSDictionary class]]) {
            
            cell.lblSubTitle.text = businessData[@"content"];
            cell.lblTime.text = businessData[@"createTime"];
//            BOOL notRead = [businessData[@"handleStatus"] integerValue] == 0;
            
        } else {
            cell.lblSubTitle.text = @"暂无新的消息";
        }
        
        [_messageDotBusiness installTo:cell.ivLogo];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        UNPSystemMessageVC *vc = [[UNPSystemMessageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){
    
        UNPBusinessMessageVC *vc = [[UNPBusinessMessageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


@end
