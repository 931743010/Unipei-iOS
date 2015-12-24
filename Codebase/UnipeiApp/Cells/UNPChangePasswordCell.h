//
//  UNPChangePasswordCell.h
//  DymIOSApp
//
//  Created by xujun on 15/12/10.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNPChangePasswordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *tfOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPasswordAgain;

@end
