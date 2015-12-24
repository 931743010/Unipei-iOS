//
//  JPOrderTrackCell.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/29.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "JPOrderTrackCell.h"
#import <Masonry/Masonry.h>

#define DOT_RADIUS      (8)

@interface JPOrderTrackCell () {
    UIView  *_dotView;
    UIView  *_lineTop;
    UIView  *_lineBottom;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conatraintBottom;


@end


@implementation JPOrderTrackCell

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
    _dotView = [UIView new];
    _dotView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _dotView.layer.cornerRadius = DOT_RADIUS;
    _dotView.hidden = YES;
    [self.contentView addSubview:_dotView];
    
    _lineTop = [UIView new];
    _lineTop.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.contentView insertSubview:_lineTop atIndex:0];
    
    _lineBottom = [UIView new];
    _lineBottom.backgroundColor = _lineTop.backgroundColor;
    [self.contentView insertSubview:_lineBottom atIndex:0];
}


- (void)awakeFromNib {
    
    [_dotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_ivLogo);
        make.width.and.height.equalTo(@(DOT_RADIUS * 2));
    }];
    
    [_lineTop mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ivLogo.mas_centerX);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(_dotView.mas_top).offset(2);
        make.width.equalTo(@1);
    }];
    
    [_lineBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ivLogo.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.top.equalTo(_dotView.mas_bottom).offset(-2);
        make.width.equalTo(@1);
    }];
}


-(void)setPos:(EJPCellPosition)pos {
    BOOL emphersis = (pos == kJPCellPositionFirst || pos == kJPCellPositionAlone);
    
    _ivLogo.hidden = !emphersis;
    _dotView.hidden = emphersis;
    _lblDesc.textColor = emphersis ? [UIColor blackColor] : [UIColor colorWithWhite:0 alpha:0.54];
    _lblTime.textColor = _lblDesc.textColor;
    
    
    ///
//    if (pos == kJPCellPositionFirst || pos == kJPCellPositionAlone) {
//        _contraintTop.constant = 20;
//    } else {
//        _contraintTop.constant = 4;
//    }
//    
//    if (pos == kJPCellPositionLast || pos == kJPCellPositionAlone) {
//        _conatraintBottom.constant = 20;
//    } else {
//        _conatraintBottom.constant = 4;
//    }
    
    ///
    if (pos == kJPCellPositionAlone) {
        _lineTop.hidden =YES;
        _lineBottom.hidden = YES;
    } else if (pos == kJPCellPositionFirst) {
        _lineTop.hidden =YES;
        _lineBottom.hidden = NO;
    } else if (pos == kJPCellPositionCenter) {
        _lineTop.hidden =NO;
        _lineBottom.hidden = NO;
    } else if (pos == kJPCellPositionLast) {
        _lineTop.hidden = NO;
        _lineBottom.hidden = YES;
    }
}

@end
