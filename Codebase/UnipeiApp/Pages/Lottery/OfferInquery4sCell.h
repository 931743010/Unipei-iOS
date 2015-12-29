//
//  OfferInquery4sCell.h
//  DymIOSApp
//
//  Created by MacBook on 12/25/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPDashedBorderedView.h"


@interface OfferInquery4sCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contrainerView;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet IPDashedBorderedView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@property (weak, nonatomic) IBOutlet UILabel *lblOeno;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;

@end
