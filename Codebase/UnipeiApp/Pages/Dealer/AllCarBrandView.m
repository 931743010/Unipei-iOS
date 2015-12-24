//
//  AllCarBrandView.m
//  DymIOSApp
//
//  Created by MacBook on 11/20/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "AllCarBrandView.h"
#import "JPIconTextButton.h"
#import <Masonry/Masonry.h>
#import "JPUtils.h"
#import "JPDesignSpec.h"


@implementation AllCarBrandView


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


-(void)doInit {
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.frame = CGRectMake(0, 0, frame.size.width, 44);
    
    JPIconTextButton *leftButton = [JPIconTextButton new];
    
    NSString *title = @"全部品牌";
  
    [leftButton setTitle:title forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    leftButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [leftButton setBackgroundColor:[UIColor clearColor]];
    
    [leftButton setImage:[UIImage imageNamed:@"icon_all_make"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 16, 0.0, 0.0)];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 32, 0.0, 0.0)];
    

    
    [self addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self);
        make.leading.equalTo(self.mas_leading);
        make.width.equalTo(self.mas_width);
    }];
    
    [leftButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}


-(void) selectButton:(UIButton *)sender
{
    NSLog(@"%s",__FUNCTION__);
    
    if (_buttonClickBlock) {
        _buttonClickBlock();
    }

}

@end
