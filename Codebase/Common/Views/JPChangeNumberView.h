//
//  JPChangeNumberView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JPNumberChangedBlock)(NSInteger number);

@interface JPChangeNumberView : UIView

@property (nonatomic, assign) NSInteger   number;

@property (nonatomic, copy) JPNumberChangedBlock    numberChangedBlock;

@end
