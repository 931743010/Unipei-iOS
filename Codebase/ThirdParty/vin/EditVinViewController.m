//
//  EditVinViewController.m
//  DymIOSApp
//
//  Created by MacBook on 11/12/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "EditVinViewController.h"
#import "UNPCreateInquiryVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EditVinViewController ()
{
    NSMutableDictionary *_retValue;
}

@end

@implementation EditVinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"核对VIN码信息";
    self.submitBtn.clipsToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5.0;
     _retValue = [NSMutableDictionary new];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.scanType) {
        NSString *_title1 = [NSString stringWithFormat:@"核对%@信息",self.scanType];
        self.title =_title1;;
        self.lblPrompt.text = [NSString stringWithFormat:@"请核对确认%@信息",self.scanType];
    }
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.vinImageView.image = self.vinResultImage;
    self.vinTextField.text = self.vinResultTxt;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmVin:(id)sender {

   [self vinInfo];

//    UNPCreateInquiryVC *target = nil;
//    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
//        if ([controller isKindOfClass:[UNPCreateInquiryVC class]]) { //这里判断是否为你想要跳转的页面
//            target = (UNPCreateInquiryVC *)controller;
//        }
//    }
//    if (target) {
//        target.vinCode = self.vinTextField.text;
//        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
////        [self.navigationController popToViewController:target animated:YES]; //跳转
//    }
}

#pragma mark Query
-(void)vinInfo
{
    @weakify(self)
    [[self vinInfoSignal] subscribeNext:^(DymBaseRespModel *result) {
        @strongify(self)
        
        if (self.scanType) {
            [_retValue setObject: self.scanType forKey:@"scanType"];
        }else{
            [_retValue setObject: @"VIN" forKey:@"scanType"];
        }

        [_retValue setObject: result forKey:@"result"];
        [_retValue setObject:self.vinTextField.text forKey:@"vinCode"];
        [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_VIN_CODE_RECOGNIZED object:_retValue];
        
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

//1G1BL52P7T0000000
//LBVCU3106DSH37179
//LDCC23141C1336812
//LFV3B28RXC3003666
//LSGPB64E9DD306118
//LSVAA49J132047371
//LWVAA1561CA010631
//WVWZZZ1KZ90000000
//cvV3B28RXC3003666
-(RACSignal *)vinInfoSignal {
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_commonApi_getVinInfo;
    api.custom_organIdKey = @"organID";
    api.params = @{@"vinCode": self.vinTextField.text};
//      api.params = @{@"vinCode": @"LDCC23141C1336812"};
    return [DymRequest commonApiSignal:api queue:self.apiQueue];
}


@end
