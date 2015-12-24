//
//  JPInquiryPartCell.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPChangeNumberView.h"

@class UNPInquiryPart;

@interface JPInquiryPartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblBaseCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblSubCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblStandardName;
@property (weak, nonatomic) IBOutlet UILabel *lblAmmount;
@property (weak, nonatomic) IBOutlet JPChangeNumberView *changeNumberView;

@property (nonatomic, assign) NSInteger         amount;

@property (nonatomic, weak) UNPInquiryPart      *inquiryPart;

@end
