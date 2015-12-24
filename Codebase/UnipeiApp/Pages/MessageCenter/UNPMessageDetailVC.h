//
//  UNPMessageDetailVC.h
//  DymIOSApp
//
//  Created by xujun on 15/11/17.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"

@interface UNPMessageDetailVC : DymBaseVC
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblReleasetime;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (nonatomic,assign) NSString        *messageID;
@end
