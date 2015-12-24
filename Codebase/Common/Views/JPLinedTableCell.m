//
//  JPLinedTableCell.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/8.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPLinedTableCell.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"

@interface JPLinedTableCell ()

@end



@implementation JPLinedTableCell


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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit {
    
    ///
    _topLine = [UIView new];
    _topLine.backgroundColor = [JPDesignSpec colorGray];
    [self.contentView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.and.top.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    _topLine.hidden = YES;
    
    
    ///
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [JPDesignSpec colorGray];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.and.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

@end
