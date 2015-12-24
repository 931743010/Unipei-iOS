//
//  DymStoyboard.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymStoryboard.h"

@implementation DymStoryboard


#pragma mark -------------------- Repair Man Storyboard ---------------------
+(UIStoryboard *) unipeiMain_Storyboard {
    return [UIStoryboard storyboardWithName:@"Unipei_Main" bundle:nil];
}

+(UIStoryboard *) unipeiOrder_Storyboard {
    return [UIStoryboard storyboardWithName:@"Unipei_Order" bundle:nil];
}

+(UIStoryboard *) unipeiInquiry_Storyboard {
    return [UIStoryboard storyboardWithName:@"Unipei_Inquiry" bundle:nil];
}

+(UIStoryboard *) common_Storyboard {
    return [UIStoryboard storyboardWithName:@"Common" bundle:nil];
}

+(UIStoryboard *) unipei_Dealer_Storyboard {
    return [UIStoryboard storyboardWithName:@"Unipei_Dealer" bundle:nil];
}

#pragma mark - Unipei main login vc
+(UIViewController *) unipeiMainLoginNC {
    return [[self unipeiMain_Storyboard] instantiateViewControllerWithIdentifier:@"loginNC"];
}


@end
