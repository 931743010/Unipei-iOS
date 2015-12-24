//
//  JPCountDownTimer.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/2.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPCountDownTimer.h"

@interface JPCountDownTimer () {
    NSTimer     *_timer;
}
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, copy) CountDownProgressBlock  progressBlock;
@end

@implementation JPCountDownTimer


-(instancetype)initWithMaxCount:(NSInteger)maxCount {
    
    self = [super init];
    if (self) {
        _maxCount = maxCount;
    }
    return self;
}

-(void)restartWithProgressBlock:(CountDownProgressBlock)progressBlock {
    [_timer invalidate];
    _progressBlock = progressBlock;
    _currentCount = _maxCount;

    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


-(void)tick:(id)sender {
    _currentCount--;
    
    if (_progressBlock) {
        _progressBlock(_currentCount);
    }
    
    if (_currentCount <= 0) {
        [_timer invalidate];
        _progressBlock = nil;
    }
}


-(void)dealloc {
    [_timer invalidate];
    _progressBlock = nil;
}

@end
