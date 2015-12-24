//
//  UNPInquiryDetailVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPMyInquiryVC.h"
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

@interface UNPMyInquiryVC () <UIGestureRecognizerDelegate> {

    id<UIGestureRecognizerDelegate> _savedSwipeBackGestRecDelegate;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet JPTabsView *tabsView;

@end

@implementation UNPMyInquiryVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPMyInquiryVC"];
}

-(void)setInquiry:(id)inquiry {
    _inquiry = inquiry;
    _inquiryID = inquiry[@"ID"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    
    self.navigationItem.title = @"询报价详情";
    
    if (_inquiry[@"listType"]) {
        _inquiryType = [_inquiry[@"listType"] integerValue];
    }
    BOOL islistTypeInquiry = (_inquiryType == kJPInquiryTypeInquiry);
    
    NSArray *titles, *normalImages, *selectedImages;
    
    if (islistTypeInquiry) {
        titles = @[@"询价单详情", @"报价单详情", @"商品清单"];
        normalImages = @[[UIImage imageNamed:@"icon_mic_gray"]
                         , [UIImage imageNamed:@"icon_comment_gray"]
                         , [UIImage imageNamed:@"icon_bag_gray"]];
        
        selectedImages = @[[UIImage imageNamed:@"icon_mic_orange"]
                           , [UIImage imageNamed:@"icon_comment_orange"]
                           , [UIImage imageNamed:@"icon_bag_orange"]];
    } else {
        titles = @[@"报价单详情", @"商品清单"];
        normalImages = @[[UIImage imageNamed:@"icon_comment_gray"]
                         , [UIImage imageNamed:@"icon_bag_gray"]];
        
        selectedImages = @[[UIImage imageNamed:@"icon_comment_orange"]
                           , [UIImage imageNamed:@"icon_bag_orange"]];
    }
    
    _tabsView.backgroundColor = [UIColor whiteColor];
    [_tabsView setTitles:titles normalImages:normalImages selectedImages:selectedImages];
    _tabsView.indexChangedBlock = ^(void) {
        @strongify(self)
        [self->_scrollView scrollToPage:self->_tabsView.selectedIndex of:self->_tabsView.tabCount];
    };
    
    NSArray *viewControllers;
    
    
    UNPInquiryDetailVC *vc1 = [UNPInquiryDetailVC newFromStoryboard];
    UNPOfferSheetVC *vc2 = [UNPOfferSheetVC newFromStoryboard];
    UNPOfferItemsVC *vc3 = [UNPOfferItemsVC newFromStoryboard];
    vc3.schemeRefusedBlock = ^(void) {
        @strongify(self)
        if (self.navigationController.presentingViewController == nil) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    if (islistTypeInquiry) {
        vc1.inquiryID = self.inquiryID;
        vc2.inquiryID = self.inquiryID;
        vc3.inquiryID = self.inquiryID;
    } else {
        vc2.quoid = self.inquiryID;
        vc3.quoid = self.inquiryID;
    }
    
    viewControllers = islistTypeInquiry ? @[vc1, vc2, vc3] : @[vc2, vc3];
    
    UIViewController *lastVC;
    for (UIViewController *vc in viewControllers) {
        
        [self addChildViewController:vc];
        [_scrollView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
        
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastVC == nil) {
                make.leading.equalTo(_scrollView.mas_leading);
                make.width.equalTo(self.view.mas_width);
                make.height.equalTo(_scrollView.mas_height);
            } else {
                make.leading.equalTo(lastVC.view.mas_trailing);
                make.width.equalTo(lastVC.view.mas_width);
                make.height.equalTo(lastVC.view.mas_height);
            }
            
            if (vc == viewControllers.lastObject) {
                make.trailing.equalTo(_scrollView.mas_trailing);
            }
            
            make.top.equalTo(_scrollView.mas_top);
            make.bottom.equalTo(_scrollView.mas_bottom);
        }];
        
        lastVC = vc;
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [_tabsView setSelectedIndex:page];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = (scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width)) * (_tabsView.buttonWidth * (_tabsView.tabCount - 1));
    [_tabsView setIndicatorLeadingOffset:offset];
}


#pragma mark - navigation swipe back gesture
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.swipeBackEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.swipeBackEnabled = YES;
}

@end
