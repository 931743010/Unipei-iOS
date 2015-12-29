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
#import "JPSensibleButton.h"
#import "UIView+Layout.h"
typedef NS_ENUM(NSInteger, EJPCouponState) {
    kJPCouponStateAvailable = 0
    , kJPCouponStateUsed
    , kJPCouponStateOutOfDate
};

@interface CouponVC ()<UIScrollViewDelegate>
{
    int _unusedCount;
    int _usedCount;
    int _pastCount;
    UIView *_illustrateView;
    
    BOOL _isShowIllustrate;
}
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
    [self loadData];
    
}
-(void)initView{
    @weakify(self)
    self.navigationItem.title = @"优惠劵";
   
    
    NSArray *title = @[[NSString stringWithFormat:@"未使用(%d)",_unusedCount],[NSString stringWithFormat:@"已使用(%d)",_usedCount],[NSString stringWithFormat:@"已过期(%d)",_pastCount]];
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
    unused.typeCoupon = kJPCouponStateAvailable;
    UnusedCoupon *used = [[UnusedCoupon alloc]initWithNibName:@"UnusedCoupon" bundle:nil];
    used.typeCoupon = kJPCouponStateUsed;
    UnusedCoupon *past = [[UnusedCoupon alloc]initWithNibName:@"UnusedCoupon" bundle:nil];
    past.typeCoupon  = kJPCouponStateOutOfDate;
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
    //使用说明
    JPSensibleButton *btn = [[JPSensibleButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [btn setTitle:@"使用说明" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (!_isShowIllustrate) {
            [UIView animateWithDuration:0.5 animations:^{
                self->_illustrateView.y = 0;
            }];
            self->_isShowIllustrate = YES;
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self->_illustrateView.y = -250;
            }];
            self->_isShowIllustrate = NO;
        }
    }];

    _illustrateView = [[UIView alloc]initWithFrame:CGRectMake(0, -250, [UIScreen mainScreen].bounds.size.width, 250)];
    _illustrateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_illustrateView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(18, 10, [UIScreen mainScreen].bounds.size.width-36, 250-20)];
    label.numberOfLines = 0;
    label.text = @"优惠券使用说明：\n\n1、优惠券是通过由你配平台抽奖、派送等形式发放给修理厂，用于减免订单应付商品金额的惠民措施。\n2、由你配平台发放的商品优惠券仅能在由你配平台（pc端、手机app）提交订单时抵减应付商品金额，不能进行兑现或其他用途。\n3、使用由你配平台优惠券的订单，若发生退货时，优惠券不予返还。\n4、由你配平台发放所有优惠券严禁出售或转让，如经发现并证实的，该券将予以作废处理。";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    [_illustrateView addSubview:label];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.5 animations:^{
        self->_illustrateView.y = -250;
        
    }];
     _isShowIllustrate = NO;
}
#pragma mark - 加载数据
-(void)loadData{
    @weakify(self);
    DymCommonApi *api = [DymCommonApi new];
    api.apiVersion = @"V2.2";
    api.custom_organIdClass = [NSString class];
    api.relativePath = PAth_inquiryApi_Coupon;
    api.params = @{@"state":[@(kJPCouponStateUsed) stringValue]
                   ,@"page":@"1",@"pageSize":@"10"};
    [[DymRequest commonApiSignal:api queue:nil] subscribeNext:^(DymBaseRespModel *result) {
        @strongify(self);
        if (result.success) {
            NSDictionary *countDic = result.body[@"UseCondition"];
            self->_unusedCount = [countDic[@"UnUsed"] intValue];
            self->_usedCount = [countDic[@"Used"] intValue];
            self->_pastCount = [countDic[@"Past"] intValue];
            [self initView];
        }
    }];
    
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
