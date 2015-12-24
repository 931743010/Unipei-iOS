//
//  UnusedCoupon.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/22.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UnusedCoupon.h"
#import "UnusedCouponCell.h"
#import "MoreCell.h"
#import "UsedCouponCell.h"

@interface UnusedCoupon ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *unUsedTable;
@property(nonatomic,assign)int stateMore;


@end

@implementation UnusedCoupon
- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateMore = 1;
    
    //设置unUsedTable相关属性
    self.unUsedTable.delegate = self;
    self.unUsedTable.dataSource = self;
    self.unUsedTable.showsVerticalScrollIndicator = NO;
    [self.unUsedTable registerNib:[UINib nibWithNibName:@"UnusedCouponCell" bundle:nil]forCellReuseIdentifier:@"cellName"];
    [self.unUsedTable registerNib:[UINib nibWithNibName:@"MoreCell" bundle:nil]forCellReuseIdentifier:@"moreCell"];
    [self.unUsedTable registerNib:[UINib nibWithNibName:@"UsedCouponCell" bundle:nil]forCellReuseIdentifier:@"cellID"];


}
#pragma mark - 加载数据
-(void)loadData{
 
}
#pragma mark -UITableViewDataSource代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.couponType == 0) {
        if (self.stateMore == 1) {
            return 4;
        }else{
            return 7;
        }
    }else if (self.couponType == 1)
    {
        return 3;
    }else{
        return 5;
    }
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.couponType == 0) {
        if (indexPath.row == 3 && self.stateMore == 1) {
            MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
            return cell;
        }else{
            UnusedCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellName"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell config];
            return cell;
        }
    }else{
        UsedCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        [cell config];
        return cell;
    
    }
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.couponType == 0&&indexPath.row == 3 && self.stateMore == 1) {
        return 60;
    }else{
        return 133;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        self.stateMore = 0;
        [self.unUsedTable reloadData];
    }
    

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
