//
//  InquiryApi_UpdateReciveAddress.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/12.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_UpdateReciveAddress : DymRequest
@property (nonatomic, copy) NSNumber    *addressID;
@property (nonatomic, copy) NSString    *contactname;
@property (nonatomic, copy) NSNumber    *state;
@property (nonatomic, copy) NSNumber    *city;
@property (nonatomic, copy) NSNumber    *district;
@property (nonatomic, copy) NSNumber    *zipcode;
@property (nonatomic, copy) NSString    *address;
@property (nonatomic, copy) NSString    *phone;

@end

//{"id":"121","organid":"1111111","contactname":"123","state":"370000","city":"371400","district":"371426","zipcode":"253100","address":"武汉1","phone":"13554011128","token":"123"}