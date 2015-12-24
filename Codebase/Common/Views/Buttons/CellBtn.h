//
//  CellBtn.h
//  DymIOSApp
//
//  Created by xujun on 15/10/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellBtn : UIButton
@property (nonatomic,strong) UIImageView *btnImage;
@property (nonatomic,strong) UILabel *btnLbl;

-(void)setBadgeNumber:(NSUInteger)number;
@end
