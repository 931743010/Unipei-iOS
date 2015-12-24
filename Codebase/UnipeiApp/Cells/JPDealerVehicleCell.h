//
//  JPDealerVehicleCell.h
//  DymIOSApp
//
//  Created by MacBook on 11/18/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLinedTableCell.h"
#import <AXRatingView/AXRatingView.h>


@interface JPDealerVehicleCell : JPLinedTableCell


@property (strong, nonatomic)  UIImageView *imageView1;

@property (strong, nonatomic)  UILabel *dealerName;
@property (strong, nonatomic)  AXRatingView *rating;
@property (strong, nonatomic)  UILabel *brand;



@end
