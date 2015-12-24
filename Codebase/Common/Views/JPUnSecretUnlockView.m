//
//  JPUnSecretUnlockView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "JPUnSecretUnlockView.h"

@interface JPUnSecretUnlockView () {
    NSArray             *_secrets;
    NSMutableArray      *_userInputs;
}

@end

@implementation JPUnSecretUnlockView

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
    
    _secrets = @[@(kJPSecrectUnlockDirectionTopLeft)
                 ,@(kJPSecrectUnlockDirectionTopRight)
                 ,@(kJPSecrectUnlockDirectionBottomRight)
                 ,@(kJPSecrectUnlockDirectionBottomLeft)
                 
                 , @(kJPSecrectUnlockDirectionTopLeft)
                 ,@(kJPSecrectUnlockDirectionTopRight)
                 ,@(kJPSecrectUnlockDirectionBottomRight)
                 ,@(kJPSecrectUnlockDirectionBottomLeft)
                 ];
    
    _userInputs = [NSMutableArray arrayWithCapacity:_secrets.count];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapped:)];
    [self addGestureRecognizer:tap];
}

-(void)handleTapped:(UITapGestureRecognizer *)tapGest {
    CGPoint pt = [tapGest locationInView:tapGest.view];
    CGFloat halfWidth = CGRectGetWidth(tapGest.view.frame) * 0.25;
    CGFloat halfHeight = CGRectGetHeight(tapGest.view.frame) * 0.25;
    
    EJPSecrectUnlockDirection direction = kJPSecrectUnlockDirectionNone;
    
    if (pt.x < halfWidth) { // left
        
        if (pt.y < halfHeight) { // top left
            direction = kJPSecrectUnlockDirectionTopLeft;
        } else if (pt.y > halfHeight * 3) { // bottom left
            direction = kJPSecrectUnlockDirectionBottomLeft;
        }
        
    } else if (pt.x > halfWidth * 3) { // right
        
        if (pt.y < halfHeight) { // top right
            direction = kJPSecrectUnlockDirectionTopRight;
        } else if (pt.y > halfHeight * 3) { // bottom right
            direction = kJPSecrectUnlockDirectionBottomRight;
        }
    }
    
    NSLog(@"tapped direction: %@", @(direction));
    
    if (_userInputs != kJPSecrectUnlockDirectionNone) {
        [_userInputs addObject:@(direction)];
    }
    
    if (_userInputs.count >= _secrets.count) {
        
        BOOL unLocked = [self checkUnlocked];
        if (_unlockBlock) {
            _unlockBlock(unLocked);
        }
        
        NSLog(@"Inupts: %@\nSecrets:%@\nUnlocked:%d", _userInputs, _secrets, unLocked);
        
        [_userInputs removeAllObjects];
    }
}

-(BOOL)checkUnlocked {
    NSAssert(_userInputs.count >= _secrets.count, @"用户输入不够啊");
    
    __block BOOL unLocked = YES;
    [_userInputs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EJPSecrectUnlockDirection direction = [obj integerValue];
        EJPSecrectUnlockDirection directionCorrect = [_secrets[idx] integerValue];
        if (direction != directionCorrect) {
            unLocked = NO;
            *stop = YES;
        }
    }];
    
    return unLocked;
}

@end
