//
//  UNPSystemMessageCell.h
//  DymIOSApp
//
//  Created by xujun on 15/11/16.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNPMessageOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblClassify;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageTitle;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
