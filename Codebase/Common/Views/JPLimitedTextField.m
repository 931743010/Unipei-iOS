//
//  JPLimitedTextField.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/9.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "JPLimitedTextField.h"
#import "JPUtils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface JPLimitedTextField () <UITextFieldDelegate>

@end

@implementation JPLimitedTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit {
//    self.delegate = self;
    
    [[self rac_textSignal] subscribeNext:^(NSString  *text) {
        NSLog(@"%@", text);
        [JPUtils restrictTextField:self maxLength:_maxLength];
    }];
}


//#pragma mark - delegate
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    /// 删除不控制
//    if (range.length != 0) {
//        return YES;
//    }
//    
//    BOOL shouldChange = YES;
////    if (textField.text.length > _maxLength) {
////        shouldChange = NO;
////    }
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (textField.text.length > _maxLength) {
//            textField.text = [textField.text substringToIndex:_maxLength];
//        }
//    });
//    
//    return shouldChange;
//}

@end
