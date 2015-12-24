//
//  JPRedDotView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/24.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPRedDotView : UIView

@property (nonatomic, assign) CGFloat  radius;
@property (nonatomic, assign) CGPoint  offset;

-(void)installTo:(UIView *)hostView;

@end
