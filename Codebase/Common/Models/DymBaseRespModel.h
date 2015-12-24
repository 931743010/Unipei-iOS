//
//  DymBaseRespModel.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseModel.h"

/// Base response model
@interface DymBaseRespModel : DymBaseModel

@property (copy, nonatomic) NSString          *msg;
@property (copy, nonatomic) NSString           *code;
@property (assign, nonatomic) BOOL            success;
@property (strong, nonatomic) id              body;


@end
