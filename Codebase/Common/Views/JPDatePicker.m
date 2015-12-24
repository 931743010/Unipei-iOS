//
//  JPDatePicker.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/30.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPDatePicker.h"
#import "JPUtils.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


static CGFloat   picker_height = 200;


@interface JPDatePicker () {
    UIView      *_blockingView;
}

@property (nonatomic, copy) JPDatePickerEventBlock  eventBlock;
@property (nonatomic, strong) MASConstraint         *constraintPickerBottom;

@end


///
@implementation JPDatePicker

+(instancetype)sharedInstance {
    static JPDatePicker *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSBundle mainBundle] loadNibNamed:@"JPDatePicker" owner:nil options:nil].firstObject;
    });
    
    return instance;
}

-(void)awakeFromNib {
    NSInteger tenYearSeconds = 3600 * 24 * 3650;
    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-tenYearSeconds];
    _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:tenYearSeconds];
    
    @weakify(self)
    [[_btnOK rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        BOOL canHide = YES;
        if (self.eventBlock) {
            canHide = self.eventBlock(kJPDatePickerConfirmed, self.datePicker.date);
        }
        
        if (canHide) {
            [self _hide:nil];
        }
    }];
    
    [[_btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        BOOL canHide = YES;
        if (self.eventBlock) {
            canHide = self.eventBlock(kJPDatePickerCancelled, self.datePicker.date);
        }
        
        if (canHide) {
            [self _hide:nil];
        }
    }];
    
    [[_datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        if (self.eventBlock) {
            self.eventBlock(kJPDatePickerValueChanged, self.datePicker.date);
        }
    }];
    
    _blockingView = [UIView new];
    _blockingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
}

-(void)_show:(void (^)(BOOL finished))completion {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:_blockingView];
    [_blockingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow);
    }];
    
    [keyWindow addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(picker_height));
        make.leading.trailing.equalTo(keyWindow);
        self.constraintPickerBottom = make.bottom.equalTo(keyWindow.mas_bottom).offset(picker_height);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.constraintPickerBottom.offset = 0;
        [UIView animateWithDuration:0.15 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    });
}

-(void)_hide:(void (^)(BOOL finished))completion {
    
    self.constraintPickerBottom.offset = picker_height;
    [UIView animateWithDuration:0.25 animations:^{
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [_blockingView removeFromSuperview];
        [self removeFromSuperview];
        
        if (completion) {
            completion(finished);
        }
    }];
}

-(void)dealloc {
    _eventBlock = nil;
}


+(void)showDate:(NSDate *)currentDate eventBlock:(JPDatePickerEventBlock)eventBlock {
    
    JPDatePicker *sharedPicker = [self sharedInstance];
    
    [sharedPicker.datePicker setDate:(currentDate ? : [NSDate date]) animated:YES];
    sharedPicker.eventBlock = eventBlock;
    
    if (sharedPicker.superview) {
        [sharedPicker _hide:^(BOOL finished) {
            [sharedPicker _show:nil];
        }];
    } else {
        [sharedPicker _show:nil];
    }
    
}


+(void)hide {
    [[self sharedInstance] _hide:nil];
}

@end
