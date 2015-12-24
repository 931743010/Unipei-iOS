//
//  CouponVC.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/22.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "CouponVC.h"
#import "JPTabsView.h"
#import "UIScrollView+Dym.h"
#import "UnusedCoupon.h"
#import <Masonry/Masonry.h>


@interface CouponVC ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet JPTabsView *tabSelect;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    @weakify(self)
    self.navigationItem.title = @"优惠劵";
    NSArray *title = @[[NSString stringWithFormat:@"未使用(%d)",2],[NSString stringWithFormat:@"已使用(%d)",0],[NSString stringWithFormat:@"已过期(%d)",0]];
    NSArray *normalImages = @[[UIImage imageNamed:@"blackIcon"]
                     , [UIImage imageNamed:@"blackIcon"]
                     , [UIImage imageNamed:@"blackIcon"]];
    NSArray *selectedImages = @[[UIImage imageNamed:@"blackIcon"]
                       , [UIImage imageNamed:@"blackIcon"]
                       , [UIImage imageNamed:@"blackIcon"]];
    _tabSelect.backgroundColor = [UIColor whiteColor];
    [_tabSelect setTitles:title normalImages:normalImages selectedImages:selectedImages];
    _tabSelect.indexChangedBlock = ^(void) {
        @strongify(self)
        [self.scrollView scrollToPage:self->_tabSelect.selectedIndex of:self->_tabSelect.tabCount];
    };
    
    NSArray *viewControllers;
    UnusedCoupon *unused = [[UnusedCoupon alloc]initWithNibName:@"UnusedCoupon" bundle:nil];
    unused.couponType = 0;
    UnusedCoupon *used = [[UnusedCoupon alloc]initWithNibName:@"UnusedCoupon" bundle:nil];
    used.couponType = 1;
    UnusedCoupon *past = [[UnusedCoupon alloc]initWithNibName:@"UnusedCoupon" bundle:nil];
    past.couponType = 2;
    viewControllers = @[unused,used,past];
    self.scrollView.pagingEnabled = YES;
    
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
#pragma mark -  scrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.tabSelect.selectedIndex = page;
  
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = (scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width)) * (_tabSelect.buttonWidth * (_tabSelect.tabCount - 1));
    [_tabSelect setIndicatorLeadingOffset:offset];
    
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
