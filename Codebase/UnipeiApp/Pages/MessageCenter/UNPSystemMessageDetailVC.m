//
//  UNPMessageDetailVC.m
//  DymIOSApp
//
//  Created by xujun on 15/11/17.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPSystemMessageDetailVC.h"
#import "JPAppStatus.h"
#import "JPIntrinsicWebView.h"


@interface UNPSystemMessageDetailVC () <UITableViewDataSource> {
    NSDictionary       *_data;
    
    UITableViewCell     *_messageCell;
    UITableViewCell     *_contentCell;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


@implementation UNPSystemMessageDetailVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard common_Storyboard] instantiateViewControllerWithIdentifier:@"UNPSystemMessageDetailVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息详情";
    self.tableView.estimatedRowHeight = self.view.frame.size.height;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getMessageDetailsData];
    
}

-(void)getMessageDetailsData{
    
    DymCommonApi *api = [DymCommonApi new];
    if (_messageID) {
        api.relativePath = PATH_remindApi_querySystemView;
        api.params = @{@"remindID":@([_messageID longLongValue]),@"userID":[JPAppStatus loginInfo].userID};
    } else if (_batchID) {
        api.relativePath = PATH_remindApi_querySystemViewByNotification;
        api.params = @{@"batchID":_batchID,@"userID":[JPAppStatus loginInfo].userID};
    }
    api.custom_organIdKey = @"organID";
    
    if (api.params != nil) {
        __weak typeof (self) weakSelf = self;
        [self showLoadingView:YES];
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
            __strong typeof (self) strongSelf = weakSelf;
            [strongSelf showLoadingView:NO];
            
            if (result.success) {
                
                _data = result.body;
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        BOOL firstLoad = NO;
        if (_messageCell == nil) {
            firstLoad = YES;
            _messageCell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
            _messageCell.backgroundColor = [UIColor clearColor];
        }
        
        UILabel *lblTitle = [_messageCell.contentView viewWithTag:101];
        UILabel *lblTime = [_messageCell.contentView viewWithTag:102];
        
        if (firstLoad) {
            [JPUtils installBottomLine:lblTime color:[UIColor colorWithWhite:0.8 alpha:1] insets:UIEdgeInsetsMake(0, 16, -6, 16)];
        }
        
        lblTitle.text = _data[@"title"];
        lblTime.text = [NSString stringWithFormat:@"发布时间:%@", _data[@"createTime"]];
        
        return _messageCell;
        
    } else if (indexPath.row == 1) {
        
        if (_contentCell == nil) {
            _contentCell = [tableView dequeueReusableCellWithIdentifier:@"contentCell" forIndexPath:indexPath];
        }
        
        JPIntrinsicWebView *webView = [_contentCell.contentView viewWithTag:101];
        webView.backgroundColor = [UIColor redColor];

        __weak typeof (self) weakSelf = self;
        webView.contentLoadedBlock = ^(void) {
            [weakSelf.tableView reloadData];
        };
        
        NSString *content = _data[@"content"];
        content = [JPUtils stringByConvertReturnTagFromHTMLString:content];
        
        NSString *linkUrl = _data[@"linkUrl"];
        if ([linkUrl isKindOfClass:[NSString class]] && linkUrl.length > 0) {
            content = [NSString stringWithFormat:@"%@\n\n链接地址: %@", content, linkUrl];
        }
        
        [webView loadPlainText:content];
        
        return _contentCell;
    }
    
    return [UITableViewCell new];
}


@end
