//
//  JPLazyBlock.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/10.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "JPLazyBlock.h"

static CGFloat delaySeconds = 0.5;

@interface JPLazyBlock () {
    NSTimer *_timer;
    
    dispatch_block_t _block;
}

@end

@implementation JPLazyBlock


-(void)excuteBlock:(dispatch_block_t)block {
    _block = block;
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:delaySeconds target:self selector:@selector(doExcute) userInfo:nil repeats:NO];
}

-(void)doExcute {
    if (_block) {
        _block();
    }
}

-(void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
