//
//  SupplementInfoCell.h
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/27.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol supplementCellDelegate <NSObject>
-(void)showPickerViewWithDate:(NSArray *)array withTag:(NSInteger)num;

@end
@interface SupplementInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel       *lblContent;
@property (nonatomic, strong) UITextField   *tfContent;
@property (nonatomic, strong) UIButton      *btnContent;
@property(nonatomic,assign)NSInteger numTag;

@property(nonatomic,assign)NSInteger typeCell;
@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,assign)id<supplementCellDelegate> delegate;
-(void)configWithStr:(NSString *)str andValue:(NSString *)valueStr;
@end
