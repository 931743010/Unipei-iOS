//
//  MineBigCell.h
//  DymIOSApp
//
//  Created by xujun on 15/10/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellBtn.h"
#import "JPLinedTableCell.h"

@protocol MineBigCellDelegate<NSObject>
-(void)selectBtn : (NSInteger)currentIndex;
@end
@interface MineBigCell : JPLinedTableCell
//@property (nonatomic,strong) CellBtn *btn;
@property (nonatomic,assign) id<MineBigCellDelegate>delegate;

-(void)setBadgeNumber:(NSUInteger)number forValue:(NSInteger)value;

@end
