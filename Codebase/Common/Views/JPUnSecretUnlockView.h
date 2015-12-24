//
//  JPUnSecretUnlockView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EJPSecrectUnlockDirection) {
    kJPSecrectUnlockDirectionNone = 0
    , kJPSecrectUnlockDirectionTopLeft
    , kJPSecrectUnlockDirectionTopRight
    , kJPSecrectUnlockDirectionBottomRight
    , kJPSecrectUnlockDirectionBottomLeft
};

typedef void(^JPSecretUnlockBlock)(BOOL unlocked);

@interface JPUnSecretUnlockView : UIView
@property (nonatomic, copy) JPSecretUnlockBlock unlockBlock;
@end
