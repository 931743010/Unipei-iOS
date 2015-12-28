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

    OfferInquery4sHeaderView *headerView = [OfferInquery4sHeaderView new];
    headerView.lblCarName.text = @"长安铃木奥拓2013款1.0L手动20周年限量版-木奥拓2013款1.0L手动20周年限量版";
    self.tableView.tableHeaderView = headerView;
}



#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferInquery4sCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerInquery4sCell" forIndexPath:indexPath];
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
