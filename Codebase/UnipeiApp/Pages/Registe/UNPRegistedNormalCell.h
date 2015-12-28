//
//  UNPRegistedNormalCell.h
//  DymIOSApp
//
//  Created by xujun on 15/12/24.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNPRegistedNormalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfContent;
@property (weak, nonatomic) IBOutlet UILabel *lblChoose;
@property (weak, nonatomic) IBOutlet UIImageView *ivChoose;

@end
