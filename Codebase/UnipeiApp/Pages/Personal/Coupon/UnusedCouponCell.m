//
//  UnusedCouponCell.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/22.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UnusedCouponCell.h"
#import "IPDashedLineView.h"
#import <Masonry.h>
@interface UnusedCouponCell()

@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *couponNum;
@property (weak, nonatomic) IBOutlet UILabel *couponPrice;
@property (weak, nonatomic) IBOutlet UIButton *couponFull;
@property (weak, nonatomic) IBOutlet UIButton *couponTime;
@property (weak, nonatomic) IBOutlet UILabel *couponTitle;

@end
@implementation UnusedCouponCell

- (void)awakeFromNib {
    

}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //设置优惠券边框圆角
    self.couponView.layer.cornerRadius = 5;
    self.couponView.clipsToBounds = YES;

    //设置优惠劵的边框
    self.couponView.layer.borderWidth = 1;
    self.couponView.layer.borderColor= [[UIColor colorWithRed:80/255 green:80/255 blue:80/255 alpha:0.2]CGColor];
    
}
-(void)configWithModel:(CouponModel *)model{
    // 水平分隔线
    IPDashedLineView *dashView = [IPDashedLineView new];
    dashView.lineColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    dashView.lengthPattern = @[@2, @1];
    [self.couponView addSubview:dashView];
    [dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponNum.mas_bottom).with.offset(4);
        make.left.equalTo(self.couponView).with.offset(0);
        make.right.equalTo(self.couponView).with.offset(0);
        make.height.equalTo(@1);
    }];
    self.couponNum.text = [NSString stringWithFormat:@"%@",model.CouponSn];
    self.couponPrice.text = [NSString stringWithFormat:@"%@",model.Amount];
    self.couponTitle.text = model.Title;
    [self.couponFull setTitle:model.OrderMinAmount forState:UIControlStateNormal];
    [self.couponTime setTitle:model.Validity forState:UIControlStateNormal];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
