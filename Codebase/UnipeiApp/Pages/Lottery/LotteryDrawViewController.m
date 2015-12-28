//
//  LotteryDrawViewController.m
//  DymIOSApp
//
//  Created by MacBook on 12/23/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "LotteryDrawViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIButton+Rotate.h"
#import "JPDesignSpec.h"
#import "DymStoryboard.h"
#import "ShowLotteryViewController.h"


static CGFloat deleyTime = 1.0f;
static int angle = 10;


@interface LotteryDrawViewController ()
{
    UIImageView *_backgroundImageView;
    UIImageView *_envelperBackground;
    UIImageView *_top;
    UIImageView *_money;
    UIButton *_btnDrawLottery;
    
    UILabel *_message;
    UIButton *_btnAbort;
}

@end

@implementation LotteryDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
// http://blog.csdn.net/woaifen3344/article/details/50114515
    
    self.navigationItem.title = @"恭喜获得一次抽奖机会";

    _backgroundImageView = [UIImageView new];
    [_backgroundImageView setImage:[UIImage imageNamed:@"redenvelopebgtop"]];

    [self.view addSubview:_backgroundImageView];
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.equalTo(self.view);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.46);
    }];
    
    
    _envelperBackground = [UIImageView new];
    [_envelperBackground setImage:[UIImage imageNamed:@"redenvelope1"]];
    [self.view addSubview:_envelperBackground];
    [_envelperBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.7);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.7);
    }];
    
    _top = [UIImageView new];
    [_top setImage:[UIImage imageNamed:@"redenvelope3"]];
    [self.view addSubview:_top];
    [_top mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_envelperBackground.mas_top);
        make.leading.equalTo(_envelperBackground.mas_leading);
        make.trailing.equalTo(_envelperBackground.mas_trailing);
       make.height.equalTo(_envelperBackground.mas_height).multipliedBy(0.7);
    }];
    
    _money = [UIImageView new];
    [_money setImage:[UIImage imageNamed:@"bg_coupon_top_money"]];
    [self.view addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_envelperBackground.mas_top).offset(-9);
        make.leading.equalTo(_envelperBackground.mas_leading).offset(30);
        make.height.equalTo(@21);
        make.height.equalTo(@32);
    }];
    
    _btnDrawLottery  = [UIButton new];
//    [_btnDrawLottery setImage:[UIImage imageNamed:@"redenvelopebutton"] forState:UIControlStateNormal];
    _btnDrawLottery.layer.cornerRadius = 40;
    _btnDrawLottery.backgroundColor = [UIColor yellowColor];
    [_btnDrawLottery setTitle:@"奖" forState:UIControlStateNormal];
    _btnDrawLottery.titleLabel.font = [UIFont systemFontOfSize:30];
    [_btnDrawLottery setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_btnDrawLottery addTarget:self action:@selector(showLotteryView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDrawLottery];
    [_btnDrawLottery mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top.mas_bottom).offset(-40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    
    _message = [UILabel new];
    [self.view addSubview:_message];
    [_message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_top.mas_leading).offset(16);
        make.trailing.equalTo(_top.mas_trailing).offset(-16);
        make.centerY.equalTo(_top.mas_centerY);
    }];
    _message.lineBreakMode = NSLineBreakByWordWrapping;
    _message.numberOfLines = 0;
    _message.text = @"点击[抢红包]\n试试手气！";
    
    _message.font = [UIFont boldSystemFontOfSize:30];//采用系统默认文字设置大小
    _message.textColor = [JPDesignSpec colorMajorHighlighted];//其中textColor要用UIColor类型
    _message.textAlignment = NSTextAlignmentCenter;
    

    //设置button下划线
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"放弃抽奖"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:strRange];  //设置颜色
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    _btnAbort = [UIButton new];
    [[_btnAbort titleLabel] setFont:[UIFont systemFontOfSize:17]];
    [_btnAbort setTitleColor:[JPDesignSpec colorMajorHighlighted] forState:UIControlStateNormal];
    [_btnAbort setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_btnAbort setAttributedTitle:str forState:UIControlStateNormal];
    [_btnAbort addTarget:self action:@selector(abortDraw:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnAbort];

    [_btnAbort mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_envelperBackground.mas_bottom).offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}


-(void)abortDraw:(UIButton *)sender{
    NSLog(@"===abortDraw");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void) showLotteryView:(UIButton *)sender{
    sender.layer.zPosition = 100;
    [sender spinButtonWithTime:deleyTime direction:angle];
    [self performSelector:@selector(delayShowLotteryView) withObject:nil afterDelay:deleyTime];
}

-(void)delayShowLotteryView{
//    LotteryDrawViewController *lotteryDrawVC = (LotteryDrawViewController *)[LotteryDrawViewController viewFromStoryboard];
//    [self.navigationController pushViewController:lotteryDrawVC animated:YES];

    
    ShowLotteryViewController *showLotteryVC = [[ShowLotteryViewController alloc] initWithNibName:@"ShowLotteryViewController" bundle:nil];
    
    [self presentViewController:showLotteryVC animated:YES completion:nil];
    
}


#pragma mark  utilty
+(instancetype)viewFromStoryboard {
    return [[DymStoryboard unipei_Lottery_Storyboard] instantiateViewControllerWithIdentifier:@"showlottery"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
