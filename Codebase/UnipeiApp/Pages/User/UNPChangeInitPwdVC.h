//
//  UNPChangeInitPwdVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/28.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseTableVC.h"
#import "ShopApi_Login.h"

@interface UNPChangeInitPwdVC : DymBaseTableVC
@property (nonatomic, strong) ShopApi_Login_Result *loginInfo;
@end
