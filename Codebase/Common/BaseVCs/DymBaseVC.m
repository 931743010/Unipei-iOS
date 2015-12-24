//
//  DymBaseVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"
#import "JPDesignSpec.h"
#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface DymBaseVC ()

@end

@implementation DymBaseVC

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [self __textFieldShouldReturn:textField];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self __doInit];
    
    
    ///
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self showEmptyView:NO text:nil];
    
    
    ///
    [self.view addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self showLoadingView:NO];
}

-(void)showEmptyView:(BOOL)show text:(NSString *)text {
    
    [self.emptyView show:show withText:text];
}

-(void)showLoadingView:(BOOL)show {
    
    [self.loadingView show:show];
}

-(void)dealloc {
    [self __doDealloc];
}


#pragma mark - orientations
- (BOOL)shouldAutorotate
{
    return [self _shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self _supportedInterfaceOrientations];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self __preferredStatusBarStyle];
}


#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

@end
