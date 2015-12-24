//
//  JPAddressNode.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseRespModel.h"

@interface JPAddressNode : DymBaseRespModel

@property (nonatomic, strong) NSNumber  *addressId;
@property (nonatomic, copy) NSString    *language;
@property (nonatomic, strong) NSNumber  *parentId;
@property (nonatomic, copy) NSString    *path;
@property (nonatomic, strong) NSNumber  *grade;
@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *token;

@end
