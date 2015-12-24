//
//  vinTyper.h
//  vinTyper
//
//  Created by etop on 15/10/20.
//  Copyright (c) 2015年 etop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VinTyper : NSObject
//授权
@property (nonatomic ,copy) NSString *nsCompanyName;
@property (nonatomic ,copy) NSString *nsReserve;

//识别结果
@property(copy, nonatomic) NSString *nsResult;
@property(strong, nonatomic) UIImage *resultImg;

//初始化核心
-(int)initVinTyper:(NSString *)nsCompanyName nsReserve:(NSString *) nsReserve;
//释放核心
- (void) freeVinTyper;
//设置检测范围
- (void) setRoiWithLeft:(int)nLeft Top:(int)nTop Right:(int)nRight Bottom:(int)nBottom;
//识别
- (int) recognizeVinTyper:(UInt8 *)buffer Width:(int)width Height:(int)height;
@end
