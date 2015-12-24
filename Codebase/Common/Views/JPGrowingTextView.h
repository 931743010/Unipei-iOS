//
//  JPGrowingTextView.h
//  TestDynamicCell
//
//  Created by Dong Yiming on 15/10/16.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPGrowingTextView : UITextView

@property (nonatomic, assign) CGFloat           placeHolderLeadingSpace;

@property (nonatomic, assign) NSInteger         maxTextCount;

@property (nonatomic, strong) UILabel           *lblPlaceHolder;

@property (nonatomic, copy) dispatch_block_t    contentHeightChangedBlock;


@end
