//
//  OfferInqueryResultFor4sViewController.m
//  DymIOSApp
//
//  Created by MacBook on 12/25/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "OfferInqueryResultFor4sViewController.h"
#import "OfferInquery4sCell.h"
#import "OfferInquery4sHeaderView.h"
#import "NSString+GGAddOn.h"

@interface OfferInqueryResultFor4sViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OfferInqueryResultFor4sViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.title = @"4S报价查询结果";

    OfferInquery4sHeaderView *headerView = [OfferInquery4sHeaderView new];
    
    NSString *title = [self trim :self.titleContent];
    
    headerView.lblCarName.text = title;
    self.tableView.tableHeaderView = headerView;
}

-(void)viewDidAppear:(BOOL)animated{
    if ([_allfoursList count]==0) {
        [self showEmptyView:YES text:@"暂无报价信息"];
    }
    
}

-(NSString *)trim:(NSString *)string{
    NSString *trimString = nil;
    trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    trimString = [trimString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return  trimString;
}


#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_allfoursList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *data= _allfoursList[indexPath.row];

//    {
//        AMOUNT = 1;
//        MODELID = 41001001;
//        NAME = "\U71c3\U6cb9\U6cf5";
//        NOTE = "\U542bABS\U7535\U8111";
//        OENO = AU7243U39U2;
//        PARTID = 41001001000001;
//        PRICE = "30941.63";
//        STANDCODE = 66;
//    }
    
//    @property (weak, nonatomic) IBOutlet UILabel *price;
//
//    @property (weak, nonatomic) IBOutlet UILabel *lblName;
//    @property (weak, nonatomic) IBOutlet UILabel *lblCode;
//    @property (weak, nonatomic) IBOutlet UILabel *lblOeno;
//    @property (weak, nonatomic) IBOutlet UILabel *lblNumber;
    
    OfferInquery4sCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerInquery4sCell" forIndexPath:indexPath];
    cell.price.text = [data[@"PRICE"] stringValue];
    cell.lblName.text = data[@"NAME"];
    cell.lblCode.text = data[@"STANDCODE"];
    cell.lblOeno.text = data[@"OENO"];
    cell.lblNumber.text = [data[@"AMOUNT"] stringValue];
//    41001001 MODELID
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
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
