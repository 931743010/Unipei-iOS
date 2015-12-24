//
//  UNPBusinessMessageDetailVC.h
//  DymIOSApp
//
//  Created by xujun on 15/11/18.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"

#warning 业务消息没有详情，so,这个页面不需要了
@interface UNPBusinessMessageDetailVC : DymBaseVC

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblReleasetime;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (nonatomic,strong) NSString *messageID;

@end
