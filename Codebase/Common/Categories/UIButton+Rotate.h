//
//  UIButton+Rotate.h
//
//  Created by QinJun on 12/23/15.
//  Copyright © 2015 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1


@interface UIButton (ButtonRotate)
- (void)spinButtonWithTime:(CFTimeInterval)inDuration direction:(int)direction;

- (void)spinInfinityButtonWithTime:(CFTimeInterval)inDuration direction:(int)direction;
- (void)stopSpinInfinityButton;

@end