//
//  UNPOfferSheetVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPOfferSheetVC.h"
#import "InquiryApi_FindQuotation.h"
#import "JPAppStatus.h"
#import "JPUtils.h"

@interface UNPOfferSheetVC () {
    UITableViewCell     *_dealerNameCell;
    UITableViewCell     *_dealerPhoneCell;
    UITableViewCell     *_quatationTitleCell;
    UITableViewCell     *_quatationStatusCell;
    UITableViewCell     *_quatationIDCell;
    UITableViewCell     *_quatationTimeCell;
    
    id              _quatation;
}

@property (strong, nonatomic)  UILabel *lblDealerName;
@property (strong, nonatomic)  UILabel *lblDealerPhone;

@property (strong, nonatomic)  UILabel *lblOfferName;
@property (strong, nonatomic)  UILabel *lblOfferID;
@property (strong, nonatomic)  UILabel *lblOfferStatus;
@property (strong, nonatomic)  UILabel *lblOfferCreateTime;

@end

@implementation UNPOfferSheetVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPOfferSheetVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emptyMessage = @"暂无报价单信息";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 48;
    
    @weakify(self)
    self.dataSourceIsLoading = YES;
    [[self findQuatationSignal] subscribeNext:^(DymBaseRespModel *result) {
        
        @strongify(self)
        self.dataSourceIsLoading = NO;
        if ([result isKindOfClass:[DymBaseRespModel class]]) {
            
            NSDictionary *body = result.body;
            self->_quatation = [body allKeys].count <= 0 ? nil : body;
            
            // {"Status":"已确认","Phone":"15812341238","Quosn":"BJ1427166749169409","Organname":"济南测试经销商","Title":"BJD:济南测试经销商","Createtime":1427166760}
            [self.tableView reloadData];
        }
        
    }];
}

#pragma mark -

/// 是否无数据显示，子类重写
-(BOOL)isDataSourceEmpty {
    return _quatation == nil;
}

/// 数据源不为空且不在加载时，section的数量，子类重写
-(NSInteger)numberOfSectionsInTableView_IfDataOK:(UITableView *)tableView {
    return 2;
}

/// 数据源不为空且不在加载时，section中row的数量，子类重写
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection_IfDataOK:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 4;
}

/// 数据源不为空且不在加载时，section header的高度，子类重写
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection_IfDataOK:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 8;
}

// 数据源不为空且不在加载时，row的高度，子类重写
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath_IfDataOK:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.emptyCell || cell == self.loadingCell) {
        return cell;
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if (_dealerNameCell == nil) {
                _dealerNameCell = [tableView dequeueReusableCellWithIdentifier:@"dealerNameCell" forIndexPath:indexPath];
                _lblDealerName = (UILabel *)[_dealerNameCell.contentView viewWithTag:100];
            }
            
            _lblDealerName.text = [_quatation objectForKey:@"Organname"];
            
            return _dealerNameCell;
            
        } else if (indexPath.row == 1) {
            
            if (_dealerPhoneCell == nil) {
                _dealerPhoneCell = [tableView dequeueReusableCellWithIdentifier:@"dealerPhoneCell" forIndexPath:indexPath];
                _lblDealerPhone = (UILabel *)[_dealerPhoneCell.contentView viewWithTag:100];
            }
            
            _lblDealerPhone.text = [_quatation objectForKey:@"Phone"];
            
            return _dealerPhoneCell;
            
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            if (_quatationTitleCell == nil) {
                _quatationTitleCell = [tableView dequeueReusableCellWithIdentifier:@"quatationTitleCell" forIndexPath:indexPath];
                _lblOfferName = (UILabel *)[_quatationTitleCell.contentView viewWithTag:100];
            }
            
            _lblOfferName.text = [_quatation objectForKey:@"Title"];
            
            return _quatationTitleCell;
            
        } else if (indexPath.row == 1) {
            
            if (_quatationIDCell == nil) {
                _quatationIDCell = [tableView dequeueReusableCellWithIdentifier:@"quatationIDCell" forIndexPath:indexPath];
                _lblOfferID = (UILabel *)[_quatationIDCell.contentView viewWithTag:100];
            }
            
            _lblOfferID.text = [_quatation objectForKey:@"Quosn"];
            
            return _quatationIDCell;
            
        } else if (indexPath.row == 2) {
            
            if (_quatationStatusCell == nil) {
                _quatationStatusCell = [tableView dequeueReusableCellWithIdentifier:@"quatationStatusCell" forIndexPath:indexPath];
                _lblOfferStatus = (UILabel *)[_quatationStatusCell.contentView viewWithTag:100];
            }
            
            _lblOfferStatus.text = [_quatation objectForKey:@"Status"];
            
            return _quatationStatusCell;
            
        } else if (indexPath.row == 3) {
            
            if (_quatationTimeCell == nil) {
                _quatationTimeCell = [tableView dequeueReusableCellWithIdentifier:@"quatationTimeCell" forIndexPath:indexPath];
                _lblOfferCreateTime = (UILabel *)[_quatationTimeCell.contentView viewWithTag:100];
            }
            
            
            CGFloat timeStamp = [[_quatation objectForKey:@"Updatetime"] longLongValue];
            _lblOfferCreateTime.text = [JPUtils timeStringFromStamp:timeStamp];
            
            return _quatationTimeCell;
        }
    }
    
    return [UITableViewCell new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor clearColor];
    
    return header;
}

#pragma mark - signals
-(RACSignal *)findQuatationSignal {
    id params = @{@"inquiryid": [JPUtils numberValueSafe:_inquiryID], @"quoid": [JPUtils numberValueSafe:_quoid]};
    
    return [DymRequest commonApiSignalWithClass:[InquiryApi_FindQuotation class] queue:self.apiQueue params:params];
}

@end
