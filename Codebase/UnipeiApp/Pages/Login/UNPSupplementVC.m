//
//  UNPSupplementVC.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/30.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPSupplementVC.h"

@interface UNPSupplementVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *supplementTab;

@end

@implementation UNPSupplementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableViewDataSource代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [self.supplementTab dequeueReusableCellWithIdentifier:@"labelCell"];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
        nameLabel.text = @"修理厂名字";
        return cell;
    }else{
        UITableViewCell *cell = [self.supplementTab dequeueReusableCellWithIdentifier:@"textFileCell"];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
        nameLabel.text = @"电话号码";
        return cell;
    
    }
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
