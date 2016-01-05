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
#import "JPSubmitButton.h"
#import "JPUtils.h"


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
    [_topBtn setImage:[UIImage imageNamed:@"icon_cross_close"] forState:UIControlStateNormal];
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
}


#pragma mark TableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        NSString *idName = [NSString stringWithFormat:@"showLottery%ld",(long)indexPath.row];
        UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: idName];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = @"红包已经放入账户中，请在[我]页查看";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(indexPath.row==1){
        UnusedCouponCell  *cell2 = [_tableView dequeueReusableCellWithIdentifier:cellName];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.couponPrice.text =[JPUtils stringValueSafe:self.coupon[@"amount"] defaultValue:@"0"];
        cell2.couponNum.text =[JPUtils stringValueSafe:self.coupon[@"couponsn"] defaultValue:@"0"];
    //    property (weak, nonatomic) IBOutlet UIView *couponView;
        //    @property (weak, nonatomic) IBOutlet UILabel *couponNum;    券号
        //    @property (weak, nonatomic) IBOutlet UILabel *couponPrice;  //钱
        //    @property (weak, nonatomic) IBOutlet UIButton *couponFull;   条件限制
        //    @property (weak, nonatomic) IBOutlet UIButton *couponTime;   时间限制
        //    @property (weak, nonatomic) IBOutlet UILabel *couponTitle;   //真送钱
        
//        {
//            "header":{"msg":"操作成功","code":"200","success":true},
//            "body":{
//                "Msg":"您今天的抽奖次数已用完，欢迎明天再来",
//                "Coupon":{
//                    "Validity":"有效期至 2016-02-04 14:11",
//                    "CouponSn":"1600558019",
//                    "State":0,
//                    "Amount":15,
//                    "OrderMinAmount":"满100元可用",
//                    "Title":"随机大放送30-90"
//       }

        NSString *validity =  [JPUtils stringValueSafe:self.coupon[@"Validity"]];
        NSString *couponsn =  [JPUtils stringValueSafe:self.coupon[@"CouponSn"]];
//        NSString *state =  [JPUtils stringValueSafe:self.coupon[@"State"]];
        NSString *amount =  [JPUtils stringValueSafe:self.coupon[@"Amount"]];
        NSString *orderMinAmount =  [JPUtils stringValueSafe:self.coupon[@"OrderMinAmount"]];
        NSString *title =  [JPUtils stringValueSafe:self.coupon[@"Title"]];
        
        cell2.couponNum.text =couponsn;
        cell2.couponPrice.text = amount;
        [cell2.couponTime setTitle:validity forState:UIControlStateNormal];
        [cell2.couponFull setTitle:orderMinAmount forState:UIControlStateNormal];
        cell2.couponTitle.text = title;

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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    footerView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1];
    
    UIColor *lineColor = [UIColor colorWithWhite:230/255.0 alpha:1];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    [JPUtils installTopLine:footerView color:lineColor insets:insets];
    
    UIButton *btnUseNow = [[JPSubmitButton alloc] initWithStyle:kJPButtonOrange];
    [btnUseNow setTitle:@"立即使用" forState:UIControlStateNormal];
    [footerView addSubview:btnUseNow];
    [btnUseNow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView).insets(UIEdgeInsetsMake(8, 16, 16, 16));
    }];
    
//    @weakify(self)
    [[btnUseNow rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        
    }];

    return footerView;
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
