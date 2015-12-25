//
//  UNP4sQueryVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/25.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNP4sQueryVC.h"
#import "JPSubmitButton.h"
#import "JPBorderedTextField.h"

@interface UNP4sQueryVC ()
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnChooseModel;
@property (weak, nonatomic) IBOutlet JPBorderedTextField *tfVinCode;

@end

@implementation UNP4sQueryVC

+(instancetype)newFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Unipei_4S" bundle:nil] instantiateViewControllerWithIdentifier:@"UNP4sQueryVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_btnChooseModel setTitle:@"啊数据库打卡机大市口街道石达开受打击书库按时打算肯德基卡as大卡司机读卡艾山街道卡速度快艾山街道卡上" forState:UIControlStateNormal];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


@end
