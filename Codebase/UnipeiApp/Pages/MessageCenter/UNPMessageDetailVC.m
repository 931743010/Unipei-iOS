//
//  UNPMessageDetailVC.m
//  DymIOSApp
//
//  Created by xujun on 15/11/17.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPMessageDetailVC.h"
#import "JPAppStatus.h"

@interface UNPMessageDetailVC ()
{
    NSDictionary       *_data;
}
@end

@implementation UNPMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息详情";
    
    [self getMessageDetailsData];
    
}
-(void)getMessageDetailsData{
    
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_remindApi_querySystemView;
    api.params = @{@"remindID":_messageID,@"userID":[JPAppStatus loginInfo].userID};
    NSLog(@">>>>>>>%@-------",_messageID);
//    api.organIdKey = @"organID";
    
    __weak typeof (self) weakSelf = self;
    [self showLoadingView:YES];
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        __strong typeof (self) strongSelf = weakSelf;
        [strongSelf showLoadingView:NO];
        
        if (result.success) {
        
            _data = result.body;
            _lblTitle.text = _data[@"title"];
            _lblReleasetime.text = _data[@"createTime"];
            _lblDetails.text = _data[@"content"];
        }
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
