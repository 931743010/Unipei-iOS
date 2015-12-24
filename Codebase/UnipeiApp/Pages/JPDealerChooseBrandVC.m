//
//  JPDealerChooseBrandVC.m
//  DymIOSApp
//
//  Created by MacBook on 11/19/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "JPDealerChooseBrandVC.h"
#import "UNPCarModelChooseVM.h"
#import "JPLazyBlock.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UnipeiApp-Swift.h>
#import "NSDictionary+Dym.h"
#import "JPDealerChooseCell.h"
#import "JPDealerConstants.h"
#import "JPAppStatus.h"
#import "AllCarBrandView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@interface JPDealerChooseBrandVC ()
{
    NSMutableArray *_brandList;
}

@property (weak, nonatomic) IBOutlet UITableView   *tableView;


@end

@implementation JPDealerChooseBrandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lazyBlock = [JPLazyBlock new];
    _brandList = [NSMutableArray new];
    _allBrands = [NSMutableDictionary dictionary];
    _sectionTitles = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    
    // Install cancel button to dismiss the pop view
    UIBarButtonItem *fixedGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedGap.width = 16;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    leftBarButton.tintColor = [UIColor colorWithWhite:0 alpha:0.54];
    self.navigationItem.leftBarButtonItems = @[fixedGap, leftBarButton];
    leftBarButton.rac_command = [self dismissPopViewCommand];
    
    
    _allBrands = [NSMutableDictionary dictionary];
    _sectionTitles = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    

    [self brandSearch];

     self.navigationItem.title = @"选择品牌";
    
    AllCarBrandView  *headerView= [[AllCarBrandView alloc] init];
    @weakify(self)
    headerView.buttonClickBlock = ^(void) {
     @strongify(self)
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyDealerChooseBrand object:nil];
               [self dismissPopView];
         };
     self.tableView.tableHeaderView=headerView;

}

-(void)viewDidAppear:(BOOL)animated
{

    
    //设置headerView高度
//    CGRect newFrame = self.tableView.tableHeaderView.frame;
//    newFrame.size.height = 80.f;
//    self.tableView.tableHeaderView.frame= newFrame;
//   NSLog(@"--2--%@",NSStringFromCGRect(self.tableView.tableHeaderView.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = _allBrands.sortedStringKeys[section];
    NSArray *brands = [_allBrands objectForKey:sectionTitle];
    return brands.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
//    static  NSString  *cellIdentiferId = @"dealerChooseCell";
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentiferId%d%d", [indexPath section], [indexPath row]];
    JPDealerChooseCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"JPDealerChooseCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *sectionTitle = _allBrands.sortedStringKeys[indexPath.section];
    NSArray *brands = [_allBrands objectForKey:sectionTitle];
    NSDictionary *brand= brands[indexPath.row];

    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:100];
    lblName.text =  [brand objectForKey:@"name"];
    NSNumber *number =  [brand objectForKey:@"num"];
//    NSLog(@"name=%@,num=%@",[brand objectForKey:@"name"],[brand objectForKey:@"num"]);
    if (number==nil || [number intValue]==0) {  //
        [lblName setTextColor:[UIColor grayColor]];
    }
    NSURL *logoURL = [NSURL URLWithString:[JPUtils fullMediaPath:[brand objectForKey:@"brandLogo"]]];
    UIImageView *ivLogo = (UIImageView *)[cell.contentView viewWithTag:101];
    [ivLogo sd_setImageWithURL:logoURL placeholderImage:[UIImage imageNamed:@"empty_photo"]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allBrands.allKeys.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _allBrands.sortedStringKeys[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_allBrands.sortedStringKeys indexOfObject:title];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = _allBrands.sortedStringKeys[indexPath.section];
    NSArray *brands = [_allBrands objectForKey:sectionTitle];
    NSDictionary *brand= brands[indexPath.row];

    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        NSNumber *num = [brand objectForKey:@"num"];
        if (num != nil && [num intValue]!=0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyDealerChooseBrand object:brand];
            [self dismissPopView];
            
        }
        else {
            [[JLToast makeText:@"该品牌没有对应的经销商"] show];
        }
    }];

}


#pragma mark query
-(RACSignal *)getInquiriesSignal {
        DymCommonApi *api = [DymCommonApi new];
        api.relativePath = PATH_commonApi_findBrandListDealer;
        api.params = @{@"unionID": [JPAppStatus loginInfo].unionID};
        return [DymRequest commonApiSignal:api queue:self.apiQueue];
}


-(void)brandSearch{
    [self showLoadingView:YES];
    @weakify(self)
    [[self getInquiriesSignal] subscribeNext:^(DymBaseRespModel *result) {
        @strongify(self)
        [self showLoadingView:NO];
        NSArray *brandList = result.body[@"brandList"];
        if ([brandList isKindOfClass:[NSArray class]]) {
            [self->_brandList removeAllObjects];
            if (result.success) {
                [self->_brandList addObjectsFromArray:brandList];
            }
            
                /// Group brands into sections
                NSMutableDictionary *allBrandsDic = [NSMutableDictionary dictionaryWithCapacity:_sectionTitles.count];
                
                for (NSString *title in _sectionTitles) {
                    [allBrandsDic setObject:[NSMutableArray array] forKey:title];
                }
                
                for (NSDictionary *brand in brandList) {
                    NSMutableArray *arr = [allBrandsDic objectForKey:[brand objectForKey:@"pyf"]];
                    [arr addObject:brand];
                }
                
                [_allBrands removeAllObjects];
                for (NSString *key in _sectionTitles) {
                    NSMutableArray *arr = [allBrandsDic objectForKey:key];
                    if (arr.count > 0) {
                        [_allBrands setObject:arr forKey:key];
                    }
                }
      
            
            [self.tableView reloadData];
        }

    }];
}

//#pragma mark headerView settings
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
////    NSLog(@"===%s",__FUNCTION__);
////    if (section==0) {
//        AllCarBrandView  *view= [[AllCarBrandView alloc] init];
//        view.buttonClickBlock = ^(void) {
////            @strongify(self)
//           [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyDealerChooseBrand object:nil];
//            [self dismissPopView];
//        };
//        return view;
////    }
////    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44.0f;
//}
@end
