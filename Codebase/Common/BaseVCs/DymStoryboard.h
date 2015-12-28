//
//  DymStoyboard.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DymStoryboard : NSObject

+(UIStoryboard *) unipeiMain_Storyboard;
+(UIStoryboard *) unipeiOrder_Storyboard;
+(UIStoryboard *) unipeiInquiry_Storyboard;
+(UIStoryboard *) common_Storyboard;
+(UIStoryboard *) unipei_Dealer_Storyboard;
+(UIStoryboard *) unipei_Lottery_Storyboard;
/// Unipei 登录VC
+(UIViewController *) unipeiMainLoginNC;

@end
