//
//  UIImage+Scale.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/8.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

-(UIImage*)scaleToFitSize:(CGSize)size;
-(NSData *)compressToMaxBytes:(NSInteger)maxBytes;
@end
