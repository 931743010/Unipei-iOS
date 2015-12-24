//
//  JPTabsView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPTabsView.h"
#import "JPIconTextButton.h"
#import <Masonry/Masonry.h>
#import "JPDesignSpec.h"
#import "JPUtils.h"

@interface JPTabsView () {
    NSMutableArray          *_buttons;
    JPIconTextButton        *_selectedButton;
    UIView                  *_indicatorView;
    
    MASConstraint           *_constraintIndicatorLeading;
}

@property (nonatomic, copy) NSArray  *titles;
@property (nonatomic, copy) NSArray  *normalImages;
@property (nonatomic, copy) NSArray  *selectedImages;

@end



@implementation JPTabsView

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
    
    _indicatorView = [UIView new];
    _indicatorView.backgroundColor = [JPDesignSpec colorMajor];
    
    [JPUtils installBottomLine:self color:[UIColor colorWithWhite:0.9 alpha:1] insets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

-(void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark -

-(void)setTitles:(NSArray *)titles normalImages:(NSArray *)normalImages selectedImages:(NSArray *)selectedImages {
    if (titles.count <= 0 || titles.count != normalImages.count || titles.count != selectedImages.count) {
        return;
    }
    
    _titles = titles;
    _normalImages = normalImages;
    _selectedImages = selectedImages;
    
    [self reinstallButtons];
}

-(void)setIndicatorLeadingOffset:(CGFloat)leadingOffset {
    _constraintIndicatorLeading.offset = leadingOffset;
}

-(NSInteger)selectedIndex {
    if (_selectedButton) {
        return [_buttons indexOfObject:_selectedButton];
    }
    
    return NSNotFound;
}

-(NSInteger)tabCount {
    return _buttons.count;
}

-(CGFloat)buttonWidth {
    return ((JPIconTextButton *)_buttons.firstObject).frame.size.width;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    [_buttons enumerateObjectsUsingBlock:^(JPIconTextButton *obj, NSUInteger idx, BOOL *stop) {
        if (idx == selectedIndex) {
            obj.selected = YES;
            
            if (_selectedButton != obj) {
                _selectedButton = obj;
                if (_indexChangedBlock) {
                    _indexChangedBlock();
                }
                
                _constraintIndicatorLeading.offset = CGRectGetMinX(_selectedButton.frame);
                [UIView animateWithDuration:0.15 animations:^{
                    [self layoutIfNeeded];
                }];
            }
            
        } else {
            obj.selected = NO;
        }
    }];
}

-(void)selectButton:(JPIconTextButton *)theButton {
    [_buttons enumerateObjectsUsingBlock:^(JPIconTextButton *obj, NSUInteger idx, BOOL *stop) {
        if (obj == theButton) {
            obj.selected = YES;
            
            if (_selectedButton != obj) {
                _selectedButton = obj;
                if (_indexChangedBlock) {
                    _indexChangedBlock();
                }
                
                _constraintIndicatorLeading.offset = CGRectGetMinX(_selectedButton.frame);
                [UIView animateWithDuration:0.15 animations:^{
                    [self layoutIfNeeded];
                }];
            }
            
            if (_buttonClickBlock) {
                _buttonClickBlock();
            }
            
        } else {
            obj.selected = NO;
        }
    }];
}

-(void)reinstallButtons {
    
    if (_titles.count <= 0) {
        return;
    }
    
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [_buttons removeAllObjects];
    
    JPIconTextButton *lastButton;
    
    CGFloat factor = 1.0 / _titles.count;
    
    for (NSInteger i = 0; i < _titles.count; i++) {
        JPIconTextButton *newButton = [JPIconTextButton new];
        
        NSString *title = _titles[i];
        [newButton setTitle:title forState:UIControlStateNormal];
        [newButton setImage:_normalImages[i] forState:UIControlStateNormal];
        [newButton setImage:_selectedImages[i] forState:UIControlStateHighlighted];
        [newButton setImage:_selectedImages[i] forState:UIControlStateSelected];
        
        [self addSubview:newButton];
        [newButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            
            if (lastButton == nil) {
                make.leading.equalTo(self.mas_leading);
            } else {
                make.leading.equalTo(lastButton.mas_trailing);
            }
            
            make.width.equalTo(self.mas_width).multipliedBy(factor);
        }];
        
        [newButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttons addObject:newButton];
        lastButton = newButton;
    }
    
    JPIconTextButton *firstButton = _buttons.firstObject;
    firstButton.selected = YES;
    
    [_indicatorView removeFromSuperview];
    [self addSubview:_indicatorView];
    [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(factor);
        make.height.equalTo(@2);
        make.bottom.equalTo(self.mas_bottom);
        _constraintIndicatorLeading = make.leading.equalTo(self.mas_leading);
    }];
}

@end
