//
//  JPCountDownTimer.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/2.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CountDownProgressBlock)(NSInteger currentCount);

@interface JPCountDownTimer : NSObject

-(instancetype)initWithMaxCount:(NSInteger)maxCount;
-(void)restartWithProgressBlock:(CountDownProgressBlock)progressBlock;

@end
