//
//  SupplementVC.h
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/29.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseTableVC.h"
#import "ShopApi_Login.h"
@interface SupplementVC : DymBaseTableVC
@property (nonatomic, strong) ShopApi_Login_Result *loginInfo;
@end
