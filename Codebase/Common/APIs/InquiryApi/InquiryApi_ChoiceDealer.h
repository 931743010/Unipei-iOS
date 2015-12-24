//
//  InquiryApi_ChoiceDealer.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/23.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_ChoiceDealer : DymRequest

@property (nonatomic, copy) NSNumber        *makeID;
@property (nonatomic, copy) NSNumber        *carID;

@end



@interface InquiryApi_ChoiceDealer_Result : DymBaseRespModel

@property (nonatomic, copy) NSArray     *dealerList;

@end