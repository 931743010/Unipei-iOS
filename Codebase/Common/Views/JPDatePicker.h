//
//  JPDatePicker.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/30.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JPDatePickerEvent) {
    kJPDatePickerValueChanged = 0
    , kJPDatePickerConfirmed
    , kJPDatePickerCancelled
};

typedef BOOL(^JPDatePickerEventBlock)(JPDatePickerEvent event, NSDate *date);

@interface JPDatePicker : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


+(instancetype)sharedInstance;

+(void)showDate:(NSDate *)currentDate eventBlock:(JPDatePickerEventBlock)eventBlock;

+(void)hide;

@end
