//
//  SettingPushVC.m
//  DymIOSApp
//
//  Created by xujun on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "SettingPushVC.h"
#import "SettingVC.h"
#import <Masonry/Masonry.h>
#import "JPSubmitButton.h"
#import "JPAppStatus.h"
#import <UnipeiApp-Swift.h>

@interface SettingPushVC ()<UITableViewDataSource ,UITableViewDelegate>
{
    CGFloat        _cacheSize ;
}

@property (weak, nonatomic) IBOutlet JPSubmitButton *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel *lblCaheSize;

@end

@implementation SettingPushVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard common_Storyboard] instantiateViewControllerWithIdentifier:@"SettingPushVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    _btnLogout.style = kJPButtonOrange;
    
    [[_btnLogout rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    
        [JPAppStatus logout];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateCacheSize];
}

-(void)updateCacheSize {
    _cacheSize = [JPUtils cacheSizeInMega];
    
    if (_cacheSize > 0.1) {
        
        _lblCaheSize.text = [NSString stringWithFormat:@"%.2fM",_cacheSize];
        
    }else{
        
        _lblCaheSize.text = @"0.00M";
        
    }
}

#pragma mark - UITableViewDatasource and Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) {
        
        if (_cacheSize > 0.1) {
            [JPUtils doAsync:^{
                [JPUtils clearCache];
            } completion:^{
                NSString *message = [NSString stringWithFormat:@"已清除%.2fM缓存文件", _cacheSize];
                [[JLToast makeTextQuick:message] show];
                _cacheSize = 0;
                _lblCaheSize.text = @"0.00M";
            }];
        } else {
            [[JLToast makeTextQuick:@"无需清除缓存"] show];
        }
        
    } else if (indexPath.section == 1) {
    
        SettingVC *vc = [SettingVC newFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
}


@end
