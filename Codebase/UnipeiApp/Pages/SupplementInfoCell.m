//
//  SupplementInfoCell.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/27.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "SupplementInfoCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry.h>
@interface SupplementInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
@implementation SupplementInfoCell
-(void)configWithStr:(NSString *)str andValue:(NSString *)valueStr{
     if (self.typeCell == 0) {
        UILabel *valueLabel = [[UILabel alloc]init];
        valueLabel.text = valueStr;
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.nameLabel).with.offset(80);
        }];
     }else if (self.typeCell == 1){
         UITextField *textFile = [[UITextField alloc]init];
         textFile.placeholder = valueStr;
         [self.contentView addSubview:textFile];
         [textFile mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(self.contentView);
             make.left.equalTo(self.nameLabel).with.offset(80);
             make.right.equalTo(self.contentView).with.offset(-40);

         }];
     }else if (self.typeCell == 2){
         UIButton *button = [UIButton new];
         [button setTitle:valueStr forState:UIControlStateNormal];
         [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
         @weakify(self)
         [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
             @strongify(self)
             [self.delegate showPickerViewWithDate:self.dataArray];
         }];
         [self.contentView addSubview:button];
         [button mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(self.contentView);
             make.left.equalTo(self.nameLabel).with.offset(80);
             make.right.equalTo(self.contentView).with.offset(-40);
             make.height.equalTo(@40);
         }];
     }
    self.nameLabel.text = str;
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
