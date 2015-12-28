//
//  SupplementInfoCell.h
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/27.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol supplementCellDelegate <NSObject>
-(void)showPickerViewWithDate:(NSArray *)array;

@end
@interface SupplementInfoCell : UITableViewCell
@property(nonatomic,assign)int typeCell;
@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,assign)id<supplementCellDelegate> delegate;
-(void)configWithStr:(NSString *)str andValue:(NSString *)valueStr;
@end
