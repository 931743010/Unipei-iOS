//
//  UNPChooseBrandVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseBrandVC.h"
#import "JPSubmitButton.h"
#import "JPUtils.h"
#import "JPDesignSpec.h"
#import "UNPChooseSeriesVC.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDictionary+Dym.h"
#import <UnipeiApp-Swift.h>
#import "JPLazyBlock.h"

//static const DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface UNPChooseBrandVC ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnNext;
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnOK;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) JPLazyBlock  *lazyBlock;

@end

@implementation UNPChooseBrandVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPChooseBrandVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lazyBlock = [JPLazyBlock new];
    
    // Install cancel button to dismiss the pop view
    UIBarButtonItem *fixedGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedGap.width = 16;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    leftBarButton.tintColor = [UIColor colorWithWhite:0 alpha:0.54];
    self.navigationItem.leftBarButtonItems = @[fixedGap, leftBarButton];
    leftBarButton.rac_command = [self dismissPopViewCommand];
    
    /// ok and next buttons
//    _btnOK.style = kJPButtonOrange;
//    _btnNext.style = kJPButtonWhite;
//    [_btnNext setTitleColor:[UIColor colorWithWhite:0 alpha:0.87] forState:UIControlStateNormal];
//    _btnNext.layer.borderColor = [UIColor colorWithHex:0x9a9a9a].CGColor;
//    [JPUtils installTopLine:_bottomView color:[UIColor colorWithWhite:0.95 alpha:1] insets:UIEdgeInsetsZero];
//    
//    @weakify(self)
//    [[_btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
//        if (self->_viewModel.brandVM.selectedItem != nil) {
//            
//            UNPChooseSeriesVC *vc = [UNPChooseSeriesVC new];
//            vc.viewModel = _viewModel;
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        } else {
//            [[JLToast makeText:@"请先选择品牌"] show];
//        }
//    }];
    
//    [[_btnOK rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
//        if (self->_viewModel.brandVM.selectedItem != nil) {
//            
//            [_viewModel.seriesVM reset];
//            [_viewModel.yearVM reset];
//            [_viewModel.modelVM reset];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_String_carModelSelected object:_viewModel];
//            
//            [self dismissPopView];
//            
//        } else {
//            [[JLToast makeText:@"请先选择品牌"] show];
//        }
//    }];
    
    
    /// request data
    if (_viewModel.brandVM.items.count <= 0) {
        @weakify(self)
        [self.loadingView show:YES];
        [_viewModel getAllMakes:^(ModelPictureApi_FindMakeList_Result *result) {

            @strongify(self)
            [self.loadingView show:NO];
            if ([result isKindOfClass:[ModelPictureApi_FindMakeList_Result class]]) {
                [self.tableView reloadData];
            }
        } queue:self.apiQueue];
    }
    
    
    self.navigationItem.title = _viewModel.brandVM.title;
}


#pragma mark - table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = _viewModel.allBrands.sortedStringKeys[section];
    NSArray *brands = [_viewModel.allBrands objectForKey:sectionTitle];
    return brands.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brandCell" forIndexPath:indexPath];
    
    NSString *sectionTitle = _viewModel.allBrands.sortedStringKeys[indexPath.section];
    NSArray *brands = [_viewModel.allBrands objectForKey:sectionTitle];
    JPCarMake *brand = brands[indexPath.row];
    
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:100];
    lblName.text = brand.mName;
    
    NSURL *logoURL = [NSURL URLWithString:[JPUtils fullMediaPath:brand.carlogo]];
    UIImageView *ivLogo = (UIImageView *)[cell.contentView viewWithTag:101];
    [ivLogo sd_setImageWithURL:logoURL placeholderImage:[UIImage imageNamed:@"empty_photo"]];
    
    JPCarMake *selectedBrand = [_viewModel.brandVM selectedItem];
    [cell.contentView viewWithTag:102].hidden = ( [brand.makeid longLongValue] != [selectedBrand.makeid longLongValue]);
    
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel.allBrands.allKeys.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _viewModel.allBrands.sortedStringKeys[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _viewModel.sectionTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_viewModel.allBrands.sortedStringKeys indexOfObject:title];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionTitle = _viewModel.allBrands.sortedStringKeys[indexPath.section];
    NSArray *brands = [_viewModel.allBrands objectForKey:sectionTitle];
    JPCarMake *brand = brands[indexPath.row];
    
    [_viewModel.brandVM selectItem:brand];
    
    [tableView reloadData];
    
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        if (self.viewModel.brandVM.selectedItem != nil) {
            
            UNPChooseSeriesVC *vc = [UNPChooseSeriesVC new];
            vc.viewModel = self.viewModel;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            [[JLToast makeText:@"请先选择品牌"] show];
        }
    }];
}

@end
