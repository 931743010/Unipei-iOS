//
//  TopView.m
//
//  Created by etop on 15/10/25.
//  Copyright (c) 2015年 etop. All rights reserved.
//

#import "TopView.h"
#import <CoreText/CoreText.h>

@implementation TopView{
    
    CGPoint ldown;
    CGPoint rdown;
    CGPoint lup;
    CGPoint rup;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect_screen = [[UIScreen mainScreen]bounds];
        CGSize size_screen = rect_screen.size;
        CGFloat width = size_screen.width;
        CGFloat height = size_screen.height;
        if (width==375 && height== 667) {//苹果6
            //横屏预览视图 左下角 右下角 左上角 右上角 (顶点)
            ldown = CGPointMake(110*1.174, 100*1.174);
            rdown = CGPointMake(110*1.174, 455*1.174);
            lup = CGPointMake(210*1.174, 100*1.174);
            rup = CGPointMake(210*1.174, 455*1.174);
            self.smallrect = CGRectMake(110*1.174, 100*1.174, 100*1.174, 355*1.174);
            
        }else if (width==320&&height==568){//苹果5
            ldown = CGPointMake(110, 100);
            rdown = CGPointMake(110, 455);
            lup = CGPointMake(210, 100);
            rup = CGPointMake(210, 455);
            self.smallrect = CGRectMake(110, 100, 100, 355);
        }else if (width==320&&height==480){//苹果4
            ldown = CGPointMake(110, 100-44);
            rdown = CGPointMake(110, 455-44);
            lup = CGPointMake(210, 100-44);
            rup = CGPointMake(210, 455-44);
            self.smallrect = CGRectMake(110, 100-44, 100, 355);
            
        }else if (height == 736){//6plus
            ldown = CGPointMake(110*1.295, 100*1.295);
            rdown = CGPointMake(110*1.295, 455*1.295);
            lup = CGPointMake(210*1.295, 100*1.295);
            rup = CGPointMake(210*1.295, 455*1.295);
            self.smallrect = CGRectMake(110*1.295, 100*1.295, 100*1.295, 355*1.295);
        }
    }
    return self;
}


- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    [[UIColor yellowColor] set];
    [[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0] set];
    //获得当前画布区域
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置线的宽度
    CGContextSetLineWidth(currentContext, 2.0f);
    
    /*画线*/
    //起点--左下角
    CGContextMoveToPoint(currentContext,ldown.x, ldown.y+25);
    CGContextAddLineToPoint(currentContext, ldown.x, ldown.y);
    CGContextAddLineToPoint(currentContext, ldown.x+25, ldown.y);
    
    //右下角
    CGContextMoveToPoint(currentContext, rdown.x,rdown.y-25);
    CGContextAddLineToPoint(currentContext, rdown.x,rdown.y);
    CGContextAddLineToPoint(currentContext, rdown.x+25,rdown.y);
    
    //左上角
    CGContextMoveToPoint(currentContext, lup.x-25,lup.y);
    CGContextAddLineToPoint(currentContext, lup.x,lup.y);
    CGContextAddLineToPoint(currentContext, lup.x,lup.y+25);
    
    //右上角
    CGContextMoveToPoint(currentContext, rup.x, rup.y-25);
    CGContextAddLineToPoint(currentContext, rup.x, rup.y);
    CGContextAddLineToPoint(currentContext, rup.x-25, rup.y);
    
    CGContextStrokePath(currentContext);
}

@end
