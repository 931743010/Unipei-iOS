//
//  JPInquiryDealerCell.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/16.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPInquiryDealerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDealerName;
@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblDealerPhone;

@end
