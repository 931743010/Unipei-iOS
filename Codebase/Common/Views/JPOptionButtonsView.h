//
//  JPOptionButtonsView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPOptionButtonsView : UIView

@property (nonatomic, assign) NSInteger selectedValue;

@property (nonatomic, copy) dispatch_block_t valueChangedBlock;

-(void)setValues:(NSArray *)values titles:(NSArray *)titles;

@end
