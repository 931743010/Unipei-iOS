//
//  FrequentPartViewController.m
//  DymIOSApp
//
//  Created by MacBook on 11/17/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "FrequentPartViewController.h"
#import "JPDealerVehicleCell.h"
#import "DymCommonApi.h"
#import "JPAppStatus.h"
#import "JPUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <UnipeiApp-Swift.h>
#import "JPDealerConstants.h"
#import "UNPCarModelChooseVM.h"
#import "UNPCarPartsChooseVM.h"
#import <Masonry/Masonry.h>
#import "JPDealerDetailVC.h"
#import "DymStoryboard.h"

static const NSInteger  pageSize = 20;

@interface FrequentPartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray          *_vehicleDealerList;
    UIRefreshControl        *_refreshControl;
    CGFloat                 _pageIndex;  // start from 1
    BOOL                    _hasMore;
    BOOL                    _hasRequestedInquiryList;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FrequentPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getFirstPage];
    
    @weakify(self)
    _vehicleDealerList = [NSMutableArray arrayWithCapacity:pageSize];
    _hasMore = YES;
    _pageIndex = 1;
    
    // Pull to Refresh
    _refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_refreshControl];
    [[_refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self getFirstPage];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [self getNextPage];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshpage) name:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
}


-(void)refreshpage{
    _pageIndex  = 1;
    [self->_vehicleDealerList removeAllObjects];
    [self getFirstPageAndShowLoading];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _vehicleDealerList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"dealerCellId";
    JPDealerVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[JPDealerVehicleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    id dealer = _vehicleDealerList[indexPath.row];
    
    //{"id":169596,"logo":"","score":"","brandName":"奥特佳,一汽","organName":"经销商-曹为香"},
    
    NSString *logoPath= [dealer objectForKey:@"logo"];
    NSURL *logoURL = [NSURL URLWithString:[JPUtils fullMediaPath:logoPath]];
    UIImageView *dealerImageView =  cell.imageView1;  //cell本身就有个imageView。自定义的cell不能再命名这个名字
    [dealerImageView sd_setImageWithURL:logoURL placeholderImage:[UIImage imageNamed:@"icon_goods_logo_default"]];
    
    NSString * majorBand  = [NSString stringWithFormat:@"主营车系: %@",[JPUtils stringReplaceNil:dealer[@"brandName"] defaultValue:@"暂无数据"]];
    cell.brand.text =  majorBand;
    cell.dealerName.text = [dealer objectForKey:@"organName"];

    
    NSNumber *score =  [dealer objectForKey:@"score"];
    [cell.rating sizeToFit];
    [cell.rating setUserInteractionEnabled:NO];
    [cell.rating setNumberOfStar:5];
    [cell.rating setValue:[score intValue]];
    
    return cell;
    
}

#pragma mark UITableViewDelegate
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
////    JPDealerVehicleCell *cell =  (JPDealerVehicleCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
////    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
////    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
////    NSDictionary *attributes = @{NSFontAttributeName:cell.brand.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
////    
////    CGSize labelSize = [cell.brand.text boundingRectWithSize:CGSizeMake(150, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
////    
////    return  labelSize.height + 80;
//    
//    CGFloat  screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    
//    JPDealerVehicleCell *cell =  (JPDealerVehicleCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes = @{NSFontAttributeName:cell.brand.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
//    
//    CGSize labelSize = [cell.brand.text boundingRectWithSize:CGSizeMake(screenWidth-140, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//        cell.brand.frame = CGRectMake(cell.brand.frame.origin.x, cell.brand.frame.origin.y, labelSize.width, labelSize.height);
//    return  labelSize.height + 115;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id dealer = _vehicleDealerList[indexPath.row];
    if (dealer) {
        JPDealerDetailVC *dealerDetailVC = (JPDealerDetailVC *)[FrequentPartViewController newFromStoryboard];
        dealerDetailVC.dealer =dealer;
        [self.navigationController pushViewController:dealerDetailVC animated:YES];
    }
    
}



#pragma mark
#pragma mark - requests

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipei_Dealer_Storyboard] instantiateViewControllerWithIdentifier:@"JPDealerDetailVC"];
}

//外界通知后查询
-(void)getFirstPageAndShowLoading {
    
    [self getFirstPage];
    [self.tableView setContentOffset:CGPointMake(0, -CGRectGetHeight(_refreshControl.frame)) animated:YES];
}

-(void)getFirstPage {
    _pageIndex = 1;
    _hasMore = YES;
    
    [self getInquiries];
    
    [_refreshControl beginRefreshing];
    self.tableView.showsInfiniteScrolling = NO;
}

-(void)getNextPage {
    if (_hasMore) {
        _pageIndex ++;
        [self getInquiries];
    }
}


-(void)getInquiries {
    [self showLoadingView:YES];
    @weakify(self)
    [[self getInquiriesSignal] subscribeNext:^(DymBaseRespModel *result) {
        
        @strongify(self)
        [self showLoadingView:NO];
        self->_hasRequestedInquiryList = YES;
        NSArray *dealerList = result.body[@"dealers"];
        if ([dealerList isKindOfClass:[NSArray class]]) {
            
            if (self->_pageIndex <= 1) {
                [self->_vehicleDealerList removeAllObjects];
            }
            
            if (result.success) {
                [self->_vehicleDealerList addObjectsFromArray:dealerList];
                
                if (dealerList.count <= 0) {
                    _hasMore = NO;
                    self.tableView.showsInfiniteScrolling = NO;
                    
                    if (_pageIndex > 1) {
                        [[JLToast makeTextQuick:@"没有更多了"] show];
                    }
                    
                } else if (dealerList.count > 0 && dealerList.count < pageSize) {
                    // 如果返回的数据条数大于0但小于pageSize，就视为最后一页数据
                    _hasMore = NO;
                    self.tableView.showsInfiniteScrolling = NO;
                    
                } else {
                    _hasMore = YES;
                    self.tableView.showsInfiniteScrolling = YES;
                }
                
                [self->_refreshControl endRefreshing];
                [self.tableView.infiniteScrollingView stopAnimating];
                
            } else {
                self.tableView.showsInfiniteScrolling = NO;
                [self.tableView.infiniteScrollingView stopAnimating];
                [self->_refreshControl endRefreshing];
            }
            
            [self.tableView reloadData];
            
        } else {
            self.tableView.showsInfiniteScrolling = NO;
            [self.tableView.infiniteScrollingView stopAnimating];
            [self->_refreshControl endRefreshing];
        }
    }];
}


#pragma mark - signals


-(RACSignal *)getInquiriesSignal {
    

    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_dealerApi_allDealerList;
    api.params = @{@"unionID": [JPAppStatus loginInfo].unionID
                   , @"pageIndex": @(_pageIndex), @"pageSize": @(pageSize)
                   , @"isCommonParts": @1};
    return [DymRequest commonApiSignal:api queue:self.apiQueue];

}



@end
