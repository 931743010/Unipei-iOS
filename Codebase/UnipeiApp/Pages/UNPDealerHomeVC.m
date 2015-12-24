//
//  UNPDealerHomeVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPDealerHomeVC.h"

#import "UIViewController+PSContainment.h"
#import "JPDesignSpec.h"
#import "UIScrollView+Dym.h"
#import <SwipeBack/SwipeBack.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UNPInquiryDetailVC.h"
#import "UNPOfferSheetVC.h"
#import "UNPOfferItemsVC.h"
#import "JPTabsView.h"
#import "DymStoryboard.h"
#import <Masonry/Masonry.h>
#import "InquiryApi_InquiryList.h"

#import "FrequentPartViewController.h"
#import "FullVehiclePartViewController.h"
#import "UNPChooseBrandVC.h"
#import "JPSidePopVC.h"
#import "UNPCarModelChooseVM.h"
#import "JPDealerChooseBrandVC.h"
#import "JPSensibleButton.h"


@interface UNPDealerHomeVC ()
@property (weak, nonatomic) IBOutlet JPTabsView *tabBarView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation UNPDealerHomeVC
{
    /// 选择车型的View Model
    UNPCarModelChooseVM     *_carModelChooseVM;
    
    FullVehiclePartViewController *_fullVehiclePartVC;
    FrequentPartViewController  *_frequentPartVC;
    
    NSInteger _oldPageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _oldPageIndex = 0;
    _carModelChooseVM = [UNPCarModelChooseVM new];
    
    self.navigationItem.title = @"经销商";
    [self.contentScrollView  setShowsHorizontalScrollIndicator:NO];
    
    NSArray *titles, *normalImages, *selectedImages;
    
    
    titles = @[@"全车件", @"常用件"];
    normalImages = @[[UIImage imageNamed:@"icon_comment_gray"]
                     , [UIImage imageNamed:@"icon_bag_gray"]];
    selectedImages = @[[UIImage imageNamed:@"icon_comment_orange"]
                       , [UIImage imageNamed:@"icon_bag_orange"]];
    
    @weakify(self)
    
    
    // Install cancel button to dismiss the pop view
    // Filter inquiry button
    JPSensibleButton *btnFilter = [[JPSensibleButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [btnFilter setImage:[UIImage imageNamed:@"btn_filter"] forState:UIControlStateNormal];
    [[btnFilter rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (_tabBarView.selectedIndex==0) {  //全车件
        JPDealerChooseBrandVC *vc = [[JPDealerChooseBrandVC alloc]initWithNibName:@"JPDealerChooseBrandVC" bundle:nil];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [[JPSidePopVC new] showVC:nc];
        [self.view endEditing:YES];
        }
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnFilter];
    
    
    _tabBarView.backgroundColor = [UIColor whiteColor];
    [_tabBarView setTitles:titles normalImages:normalImages selectedImages:selectedImages];
    _tabBarView.indexChangedBlock = ^(void) {
        @strongify(self)
        [self->_contentScrollView scrollToPage:self->_tabBarView.selectedIndex of:self->_tabBarView.tabCount];
    };

    _tabBarView.buttonClickBlock = ^(void) {
        @strongify(self)
        if (_tabBarView.selectedIndex==0) {  //全车件
            if (!self.navigationItem.rightBarButtonItem) {
                  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnFilter];
            }

            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            
//            [_fullVehiclePartVC setFullSearchStatus];
        }
//        [self changeRightBarButtonItemStatus];
        if (_tabBarView.selectedIndex==1){//常用件
              self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
    };
    
    NSArray *viewControllers;
    _frequentPartVC = [[FrequentPartViewController alloc] initWithNibName:@"FrequentPartViewController" bundle:nil];
    _fullVehiclePartVC = [[FullVehiclePartViewController alloc] initWithNibName:@"FullVehiclePartViewController" bundle:nil];
    
    viewControllers = @[_fullVehiclePartVC,_frequentPartVC];
    
    [_contentScrollView setPagingEnabled:YES];
    
    UIViewController *lastVC;
    for (UIViewController *vc in viewControllers) {
        
        [self addChildViewController:vc];
        [_contentScrollView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
        
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastVC == nil) {
                make.leading.equalTo(_contentScrollView.mas_leading);
                make.width.equalTo(self.view.mas_width);
                make.height.equalTo(_contentScrollView.mas_height);
            } else {
                make.leading.equalTo(lastVC.view.mas_trailing);
                make.width.equalTo(lastVC.view.mas_width);
                make.height.equalTo(lastVC.view.mas_height);
            }
            
            if (vc == viewControllers.lastObject) {
                make.trailing.equalTo(_contentScrollView.mas_trailing);
            }
            
            make.top.equalTo(_contentScrollView.mas_top);
            make.bottom.equalTo(_contentScrollView.mas_bottom);
        }];
        
        lastVC = vc;
    }
    
    
    
    

}

#pragma mark choose brand

-(void) popChooseBrand
{
    JPDealerChooseBrandVC *vc = [[JPDealerChooseBrandVC alloc]initWithNibName:@"JPDealerChooseBrandVC" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [[JPSidePopVC new] showVC:nc];
    [self.view endEditing:YES];
}



#pragma mark -  scrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [_tabBarView setSelectedIndex:page];
    //滚动发生变化
//    if (_oldPageIndex!=page) {
        [self changeRightBarButtonItemStatus:page];
//        _oldPageIndex=page;
//    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = (scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width)) * (_tabBarView.buttonWidth * (_tabBarView.tabCount - 1));
    [_tabBarView setIndicatorLeadingOffset:offset];

}

-(void)changeRightBarButtonItemStatus:(NSInteger)currentPage
{
//    self.navigationItem.rightBarButtonItem.customView.hidden = !self.navigationItem.rightBarButtonItem.customView.hidden;
    
    if (currentPage==0) {  //全车件
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    if (currentPage==1){//常用件
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }

}


@end
