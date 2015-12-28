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


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)awakeFromNib {
    [_lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel).with.offset(80);
    }];
    
    [_tfContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel).with.offset(80);
        make.right.equalTo(self.contentView).with.offset(-40);
        
    }];
    
    [_btnContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel).with.offset(80);
        make.right.equalTo(self.contentView).with.offset(-40);
        make.height.equalTo(@40);
    }];
}

-(void)doInit {
    _lblContent = [[UILabel alloc]init];
    _lblContent.font = [UIFont systemFontOfSize:14];
    _lblContent.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_lblContent];
    
    
    //
    _tfContent = [[UITextField alloc]init];
    [self.contentView addSubview:_tfContent];
    
    
    
    //
    _btnContent = [UIButton new];
    [_btnContent setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    @weakify(self)
    [[_btnContent rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.delegate showPickerViewWithDate:self.dataArray withTag:_btnContent.tag];
    }];
    [self.contentView addSubview:_btnContent];
    
    
    _lblContent.hidden = _btnContent.hidden = _tfContent.hidden = YES;
}

-(void)configWithStr:(NSString *)str andValue:(NSString *)valueStr{
    
    _lblContent.hidden = _btnContent.hidden = _tfContent.hidden = YES;
     if (self.typeCell == 0) {
         _lblContent.hidden = NO;
         _lblContent.text = valueStr;
         
     }else if (self.typeCell == 1){
         _tfContent.hidden = NO;
         _tfContent.tag = 300+self.numTag;
         _tfContent.placeholder = valueStr;
     }else if (self.typeCell == 2){
         _btnContent.hidden = NO;
         [_btnContent setTitle:valueStr forState:UIControlStateNormal];
     }
    self.nameLabel.text = str;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
