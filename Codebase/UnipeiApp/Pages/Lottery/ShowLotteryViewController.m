//
//  ShowLotteryViewController.m
//  DymIOSApp
//
//  Created by MacBook on 12/24/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "ShowLotteryViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JPDesignSpec.h"
#import "DymStoryboard.h"
#import "UnusedCouponCell.h"

static NSString *cellName = @"UnusedCouponCell";


@interface ShowLotteryViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ShowLotteryViewController
{
    UIImageView *_topView;
    UIButton *_topBtn;
    UILabel *_topMessage;
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topView = [UIImageView new];
    [_topView setImage:[UIImage imageNamed:@"redenvelopetop"]];
    
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.equalTo(self.view);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.3);
    }];
    
    _topBtn = [UIButton new];
    [_topBtn setImage:[UIImage imageNamed:@"redenvelopeclock1"] forState:UIControlStateNormal];
    [_topBtn addTarget:self action:@selector(backView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topBtn];
    [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(36);
        make.leading.equalTo(self.view.mas_leading).offset(16);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    _topMessage = [UILabel new];
    _topMessage.text = @"恭喜你抽中一个红包";
    _topMessage.font = [UIFont boldSystemFontOfSize:18];
    _topMessage.textColor = [JPDesignSpec colorWhite];
    _topMessage.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_topMessage];
    [_topMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(36);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@260);
        make.height.equalTo(@30);
    }];
    
    _tableView=[UITableView new];
    _tableView.dataSource= self;
    _tableView.delegate= self;
    
    
    UINib *cellNib = [UINib nibWithNibName:cellName bundle:nil];
    
    [_tableView registerNib:cellNib forCellReuseIdentifier:cellName];
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
}

-(void)backView:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    NSLog(@"--backView--");
}


#pragma mark TableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        NSString *idName = [NSString stringWithFormat:@"showLottery%ld",indexPath.row];
        UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: idName];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = @"红包已经放入账户中，请在[我]页查看";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(indexPath.row==1){
        UnusedCouponCell  *cell2 = [_tableView dequeueReusableCellWithIdentifier:cellName];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40;
    } else if (indexPath.row == 1) {
        return 150;
    }
    return 80;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
