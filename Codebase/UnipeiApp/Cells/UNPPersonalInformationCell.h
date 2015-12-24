//
//  UNPPersonalInformationCell.h
//  DymIOSApp
//
//  Created by xujun on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLinedTableCell.h"

@interface UNPPersonalInformationCell : JPLinedTableCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivHead;
@property (weak, nonatomic) IBOutlet UIImageView *ivSide;
@end
