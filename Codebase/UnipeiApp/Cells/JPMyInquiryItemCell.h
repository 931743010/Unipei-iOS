//
//  JPMyInquiryItemCell.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/16.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPSubmitButton.h"
#import "InquiryApi_InquiryList.h"

@class JPMyInquiryItemCell;

@protocol JPMyInquiryItemCellDelegate <NSObject>
@required
//-(void)willOpenInquiryItemCell:(JPMyInquiryItemCell *)cell;
//-(void)didOpenInquiryItemCell:(JPMyInquiryItemCell *)cell;
//-(void)willCloseInquiryItemCell:(JPMyInquiryItemCell *)cell;
//-(void)didCloseInquiryItemCell:(JPMyInquiryItemCell *)cell;
-(void)inquiryItemCell:(JPMyInquiryItemCell *)cell cancelAtIndex:(NSInteger)index;
-(void)inquiryItemCell:(JPMyInquiryItemCell *)cell editAtIndex:(NSInteger)index;
@end

@interface JPMyInquiryItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblOfferName;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;
@property (weak, nonatomic) IBOutlet UILabel *lblShopPhone;


@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (nonatomic, assign) BOOL                              swipable;
@property (nonatomic, weak) id<JPMyInquiryItemCellDelegate>     delegate;


//-(void)showRightButtons:(BOOL)show;
-(void)setInquryType:(EJPInquiryType)inquiryType;

-(BOOL)isOpening;

@end
