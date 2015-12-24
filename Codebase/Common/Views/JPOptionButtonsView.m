//
//  JPOptionButtonsView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPOptionButtonsView.h"
#import "JPCheckButton.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"

#define BUTTON_GAP  (8)

@interface JPOptionButtonsView () {
    NSMutableArray      *_buttons;
    JPCheckButton       *_selectedButton;
}

@property (nonatomic, copy) NSArray  *values;
@property (nonatomic, copy) NSArray  *titles;

@end

@implementation JPOptionButtonsView

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
    _buttons = [NSMutableArray array];
}

-(void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark -

-(void)setValues:(NSArray *)values titles:(NSArray *)titles {
    if (values.count <= 0 || values.count != titles.count) {
        return;
    }
    
    _values = values;
    _titles = titles;
    
    [self reinstallButtons];
}

-(NSInteger)selectedValue {
    if (_selectedButton) {
        return _selectedButton.tag;
    }
    
    return NSNotFound;
}

-(void)setSelectedValue:(NSInteger)selectedValue {
    [_buttons enumerateObjectsUsingBlock:^(JPCheckButton *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == selectedValue) {
            obj.selected = YES;
            
            if (_selectedButton != obj) {
                _selectedButton = obj;
                if (_valueChangedBlock) {
                    _valueChangedBlock();
                }
            }
            
        } else {
            obj.selected = NO;
        }
    }];
}

-(void)selectButton:(JPCheckButton *)theButton {
    [_buttons enumerateObjectsUsingBlock:^(JPCheckButton *obj, NSUInteger idx, BOOL *stop) {
        if (obj == theButton) {
            obj.selected = YES;
            
            if (_selectedButton != obj) {
                _selectedButton = obj;
                if (_valueChangedBlock) {
                    _valueChangedBlock();
                }
            }
            
        } else {
            obj.selected = NO;
        }
    }];
}

-(void)reinstallButtons {
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [_buttons removeAllObjects];
    
    JPCheckButton *lastButton;
    
    for (NSInteger i = 0; i < _values.count; i++) {
        JPCheckButton *newButton = [JPCheckButton new];
        
        NSString *title = _titles[i];
        [newButton setTitle:title forState:UIControlStateNormal];
        newButton.tag = [_values[i] integerValue];
        newButton.titleLabel.font = [UIFont systemFontOfSize:(title.length < 5 ? 14 : 12)];
        
        [self addSubview:newButton];
        [newButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@38);
            if (i % 2 == 0 || lastButton == nil) {
                make.leading.equalTo(self.mas_leading);
            } else {
                make.leading.equalTo(lastButton.mas_trailing).offset(BUTTON_GAP);
            }
            
            if (lastButton == nil) {
                make.top.equalTo(self.mas_top);
            } else if (i % 2 == 0) {
                make.top.equalTo(lastButton.mas_bottom).offset(BUTTON_GAP);
            } else {
                make.top.equalTo(lastButton.mas_top);
            }
            
            make.width.equalTo(self.mas_width).offset(-BUTTON_GAP * 0.5).multipliedBy(0.5);
        }];
        
        [newButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttons addObject:newButton];
        lastButton = newButton;
    }
    
    JPCheckButton *firstButton = _buttons.firstObject;
    firstButton.selected = YES;
}

@end
