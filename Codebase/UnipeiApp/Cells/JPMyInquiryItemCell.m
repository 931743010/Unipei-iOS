//
//  JPMyInquiryItemCell.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/16.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPMyInquiryItemCell.h"
#import "JPDesignSpec.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JPUtils.h"

static CGFloat const openLeadingOffset = -100;

@interface JPMyInquiryItemCell () {
    UIView                      *_highlightedCover;
    
    MASConstraint               *_constraintContainerLeading;
    CGFloat                     _constraintContainerLeadingValue;
    
    UIPanGestureRecognizer      *_panGest;
}

@end



@implementation JPMyInquiryItemCell

- (void)awakeFromNib {
    
    UIColor *lineColor = [JPDesignSpec colorSilver];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, -8, 16);
    [JPUtils installBottomLine:_lblTime color:lineColor insets:insets];
//    [JPUtils installBottomLine:_lblOfferName color:lineColor insets:insets];
    if ([self.reuseIdentifier isEqual:@"inquiryItemEditCell"]) {
        [JPUtils installBottomLine:_lblShopName color:lineColor insets:insets];
    }
    
    lineColor = [JPDesignSpec colorGray];
    [JPUtils installBottomLine:_containerView color:lineColor insets:UIEdgeInsetsZero];
    
    
    _highlightedCover = [UIView new];
    _highlightedCover.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];
    _highlightedCover.alpha = 0;
    [self.bgView insertSubview:_highlightedCover atIndex:0];
    [_highlightedCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    
    @weakify(self)
    [[_btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.delegate inquiryItemCell:self cancelAtIndex:self.contentView.tag];
    }];
    
    [[_btnEdit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.delegate inquiryItemCell:self editAtIndex:self.contentView.tag];
    }];
}

-(void)setSwipable:(BOOL)swipable {
    _swipable = swipable;
    
//    if (_swipable) {
//        
//        [_containerView removeFromSuperview];
//        [self.contentView addSubview:_containerView];
//        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
//            _constraintContainerLeading = make.leading.equalTo(self.mas_leading).offset(_constraintContainerLeadingValue);
//            make.width.equalTo(self.contentView.mas_width).offset(-openLeadingOffset);
//        }];
//        
//        _panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
//        _panGest.delegate = self;
//        [_containerView addGestureRecognizer:_panGest];
//    }
}

//-(void)panHandler:(UIPanGestureRecognizer *)pan {
//    if (pan.state == UIGestureRecognizerStateEnded) {
//        
//        [self showRightButtons:(_constraintContainerLeadingValue < openLeadingOffset / 2)];
//        
//    } else {
//        CGFloat offsetX = [pan translationInView:self.containerView].x;
//        _constraintContainerLeadingValue += offsetX;
//        _constraintContainerLeadingValue = MIN(0, _constraintContainerLeadingValue);
//        _constraintContainerLeadingValue = MAX(openLeadingOffset, _constraintContainerLeadingValue);
//        _constraintContainerLeading.offset = _constraintContainerLeadingValue;
//        [pan setTranslation:CGPointZero inView:self.containerView];
//    }
//}

-(void)setInquryType:(EJPInquiryType)inquiryType {
    
    if (inquiryType == kJPInquiryTypeInquiry) {
        _ivLogo.image = [UIImage imageNamed:@"icon_inquiry_inquiry"];
    } else if (inquiryType == kJPInquiryTypeNoInquiry) {
        _ivLogo.image = [UIImage imageNamed:@"icon_inquiry_quatation"];
    } else {
        _ivLogo.image = nil;
    }
}

-(BOOL)isOpening {
    return _constraintContainerLeadingValue == openLeadingOffset;
}

//-(void)showRightButtons:(BOOL)show {
//    _constraintContainerLeadingValue = show ? openLeadingOffset : 0;
//    _constraintContainerLeading.offset = _constraintContainerLeadingValue;
//
//    show ? [_delegate willOpenInquiryItemCell:self] : [_delegate willCloseInquiryItemCell:self];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.containerView layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        show ? [_delegate didOpenInquiryItemCell:self] : [_delegate didCloseInquiryItemCell:self];
//    }];
//}




-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    CGFloat alpha = highlighted ? 1 : 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        _highlightedCover.alpha = alpha;
    }];
}


#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        // Find the current vertical scrolling velocity
        CGFloat velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view].y;
        
        // Return YES if no scrolling up
        return fabs(velocity) <= 0.2;
        
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ( gestureRecognizer == _panGest ) {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        return fabs(translation.y) <= fabs(translation.x);
    }
    else {
        return YES;
    }
}

@end
