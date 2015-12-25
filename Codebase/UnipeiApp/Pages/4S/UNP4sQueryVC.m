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
#import <Masonry/Masonry.h>
#import "UNPCarModelChooseVM.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UNPChooseBrandVC.h"
#import "JPSidePopVC.h"

@interface UNP4sQueryVC () {
    UNPCarModelChooseVM     *_carModelChooseVM;
}

@property (weak, nonatomic) IBOutlet UIView *bgChooseModel;
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnChooseModel;
@property (weak, nonatomic) IBOutlet JPBorderedTextField *tfVinCode;

@property (weak, nonatomic) IBOutlet UIView *bgOE;
@property (weak, nonatomic) IBOutlet JPBorderedTextField *tfOE;

@property (weak, nonatomic) IBOutlet UIView *bgPart;
@property (weak, nonatomic) IBOutlet JPBorderedTextField *tfPart;

@property (weak, nonatomic) IBOutlet JPSubmitButton *btnSubmit;

@end

@implementation UNP4sQueryVC

+(instancetype)newFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Unipei_4S" bundle:nil] instantiateViewControllerWithIdentifier:@"UNP4sQueryVC"];
}

- (void)viewDidLoad {
    @weakify(self)
    [super viewDidLoad];
    
    self.navigationItem.title = @"4S报价查询";
    
    _carModelChooseVM = [UNPCarModelChooseVM new];
    
    _bgChooseModel.layer.masksToBounds = _bgOE.layer.masksToBounds = _bgPart.layer.masksToBounds = YES;
    _bgChooseModel.layer.cornerRadius = _bgOE.layer.cornerRadius = _bgPart.layer.cornerRadius = 5;
    _bgChooseModel.layer.borderWidth = _bgOE.layer.borderWidth = _bgPart.layer.borderWidth = 0.5;
    _bgChooseModel.layer.borderColor = _bgOE.layer.borderColor = _bgPart.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    
    _btnChooseModel.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _btnChooseModel.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnChooseModel.style = kJPButtonWhite;
    _btnChooseModel.verticalWhiteSpace = 20;
    _btnSubmit.style = kJPButtonOrange;
    
    _tfVinCode.backgroundColor = _tfOE.backgroundColor = _tfPart.backgroundColor = [UIColor clearColor];
    _tfVinCode.textField.placeholder = @"请输入17位Vin码字符/扫一扫";
    _tfOE.textField.placeholder = @"请输入OE号/扫一扫";
    _tfPart.textField.placeholder = @"请填写配件名称";
    _tfPart.rightButton.hidden = YES;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    //通知
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_String_carModelSelected object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self)
        if ([note.object isKindOfClass:[UNPCarModelChooseVM class]]) {
            self->_carModelChooseVM = note.object;
            [self->_btnChooseModel setTitle:[self->_carModelChooseVM fullName] forState:UIControlStateNormal];
        }
    }];
    
    [self.observerQueue addObject:observer];
    
    // 按钮事件
    [[_btnChooseModel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        UNPChooseBrandVC *vc = [UNPChooseBrandVC newFromStoryboard];
        vc.viewModel = [self->_carModelChooseVM copy];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [[JPSidePopVC new] showVC:nc];
        [self.view endEditing:YES];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.54 alpha:1];
    
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
    if (section == 0) {
        label.text = @"车型选择";
    } else if (section == 1) {
        label.text = @"OE号";
    } else if (section == 2) {
        label.text = @"配件名称";
    }
    
    return header;
}

@end
