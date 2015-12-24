//
//  CellBtn.m
//  DymIOSApp
//
//  Created by xujun on 15/10/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "CellBtn.h"
#import "XMBadgeView.h"
#import <Masonry/Masonry.h>

@interface CellBtn() {
    XMBadgeView *_badge;
}
@end
@implementation CellBtn

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _btnImage = [UIImageView new];
        [self addSubview:_btnImage];
        
        _btnLbl = [UILabel new];
        [_btnLbl setTextColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]];
        [_btnLbl setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_btnLbl];
        
        [_btnImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-4);
            make.width.equalTo(@32);
            make.height.equalTo(@32);
            
        }];
        
        [_btnLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_btnImage.mas_bottom).with.offset(0);
            
        }];
        
        //            还要判断数据是否为空，若为空，则不添加badge，若不为空，则添加并且根据数据给badge填充数值，若值大于99，则显示99+
        _badge = [[XMBadgeView alloc] initWithAttachView:_btnImage alignment:XMBadgeViewAlignmentTopRight];
        [_badge setBadgeBackgroundColor:[UIColor whiteColor]];
        [_badge setBadgeStrokeWidth:1];
        [_badge setBadgeStrokeColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [_badge setBadgeTextColor:[UIColor colorWithRed:237.0f/255.0f green:81.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [_badge setUserInteractionEnabled:NO];
        
    }
    
    return self;
}

-(void)setBadgeNumber:(NSUInteger)number {
    if (number == 0) {
        [_badge setBadgeText:nil];
    } else if (number < 100) {
        [_badge setBadgeText:[@(number) stringValue]];
    } else {
        [_badge setBadgeText:@"99+"];
    }
}

@end
