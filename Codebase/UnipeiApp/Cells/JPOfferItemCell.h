//
//  JPOfferItemCell.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/18.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPChangeNumberView.h"
#import "JPQuatationItem.h"

@interface JPOfferItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblItemCode;
@property (weak, nonatomic) IBOutlet UILabel *lblItemQuality;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblOECode;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketPrice;
//@property (weak, nonatomic) IBOutlet UILabel *lblSinglePrice;
@property (weak, nonatomic) IBOutlet UIImageView *ivCheck;

@property (weak, nonatomic) IBOutlet JPChangeNumberView *changeNumberView;

@property (nonatomic, weak) JPQuatationItem *quatationItem;

-(void)setChecked:(BOOL)checked;

@end
