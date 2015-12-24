//
//  JPAddressItemCell.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPAddressItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UILabel *lblPostCode;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *ivEdit;
@property (weak, nonatomic) IBOutlet UIImageView *ivCheck;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIImageView *ivDelete;


-(void)setChecked:(BOOL)checked;
-(void)setDefault:(BOOL)isDefault;

@end
