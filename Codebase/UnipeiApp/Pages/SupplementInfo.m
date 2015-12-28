//
//  SupplementInfo.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/27.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "SupplementInfo.h"
#import "JPSensibleButton.h"
#import "SupplementInfo.h"
#import <Masonry.h>
#import "SupplementInfoCell.h"
#import "SupplementInfoModel.h"
#import "SupplementInfoImage.h"
#import "JPAddPhotoView.h"
#import "UIView+Layout.h"
#import "JPAppStatus.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface SupplementInfo ()<UITableViewDataSource,UITableViewDelegate,supplementCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *_pickerView;
    UIPickerView *_picker;
    NSArray *_PickerArray;
    NSString *_btnValue;
}
@property(nonatomic,retain)UITableView *infoTab;
@end

@implementation SupplementInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.title = @"资料完善";
    [self initVC];
    _btnValue = @"点击选择";
    
}
-(UITableView *)infoTab{
    if (_infoTab == nil) {
        self.infoTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-60) style:UITableViewStylePlain];
        self.infoTab.dataSource = self;
        self.infoTab.delegate = self;
        self.infoTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _infoTab;
}
-(void)initVC{
    
    [self.view addSubview:self.infoTab];
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    alertLabel.text = @"*为必填项";
    alertLabel.textColor = [UIColor grayColor];
    alertLabel.font = [UIFont systemFontOfSize:12];
    alertLabel.backgroundColor = [UIColor lightGrayColor];
    self.infoTab.tableHeaderView = alertLabel;
    
    [self.infoTab registerNib:[UINib nibWithNibName:@"SupplementInfoCell" bundle:nil] forCellReuseIdentifier:@"cellName"];
    [self.infoTab registerNib:[UINib nibWithNibName:@"SupplementInfoImage" bundle:nil] forCellReuseIdentifier:@"cellImage"];
   
    //提交
    JPSensibleButton *submitBtn = [[JPSensibleButton alloc] initWithFrame:CGRectMake(10, screen_Height - 50- 65, screen_Width - 20, 40)];
    submitBtn.backgroundColor = [UIColor orangeColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    submitBtn.layer.cornerRadius = 3;
    [self.view addSubview:submitBtn];
    [[submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
#warning 点击提交按钮事件
        NSLog(@"提交信息");
    }];
    [self loadPickerView];
 
}
-(void)loadPickerView{
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 200)];
    _picker.delegate = self;
    _picker.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_picker];

}
#pragma mark - 加载数据
-(void)loadData{
    @weakify(self);
    DymCommonApi *api = [DymCommonApi new];
    api.apiVersion = @"V2.2";
    api.relativePath = PATH_userApi_supplementInfo;
    api.custom_organIdKey = @"organID";
    //api.params = @{@"organID":[JPAppStatus loginInfo].organID};
    [[DymRequest commonApiSignal:api queue:nil] subscribeNext:^(DymBaseRespModel *result) {
        @strongify(self);
        NSLog(@"**************%@***********",result.msg);
        if (result.success) {
           
        }
    }];
    
}
#pragma mark -UITableViewDataSource协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 10) {
        SupplementInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellName"];
        if (indexPath.row <= 2) {
            cell.typeCell = 0;
            [cell configWithStr:[SupplementInfoModel arrayWithInfo][indexPath.row]andValue:@"fgj"];
        }else if(indexPath.row <= 4){
            cell.typeCell = 1;
            [cell configWithStr:[SupplementInfoModel arrayWithInfo][indexPath.row]andValue:@"点击输入"];
        }else{
            cell.typeCell = 2;
            cell.delegate=self;
            if (indexPath.row == 6) {
                cell.dataArray = [SupplementInfoModel arrayWithYear];
            }else if (indexPath.row == 7){
                cell.dataArray = [SupplementInfoModel arrayWithArea];
            }else {
                cell.dataArray = [SupplementInfoModel arrayWithFactoryType];
            }
            [cell configWithStr:[SupplementInfoModel arrayWithInfo][indexPath.row]andValue:_btnValue];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        @weakify(self);
            SupplementInfoImage *cell = [tableView dequeueReusableCellWithIdentifier:@"cellImage"];
            [cell configWithStr:[SupplementInfoModel arrayWithInfo][indexPath.row]];
            JPAddPhotoView *_addPhotosView = (JPAddPhotoView *)[cell.contentView viewWithTag:100];
            _addPhotosView.presentingVC = self;
            _addPhotosView.maxPhotoCount = 5;
            _addPhotosView.buttonSize = 56;
            _addPhotosView.imagePickedBlock = ^(void) {
                @strongify(self)
                [self.infoTab reloadData];
            };
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 10) {
        return 140;
    }else{
        return 44;
    }
}
#pragma mark -supplementCellDelegate代理方法
-(void)showPickerViewWithDate:(NSArray *)array{
    _PickerArray = array;
    [_picker reloadAllComponents];
    [UIView animateWithDuration:0.5 animations:^{
        _picker.y  = self.view.frame.size.height-200;

    }];

}
#pragma mark -pickerView代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _PickerArray.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _PickerArray[row];
}
-(void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _btnValue = _PickerArray[row];
    [self.infoTab reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        _picker.y  = self.view.frame.size.height;
        
    }];
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
