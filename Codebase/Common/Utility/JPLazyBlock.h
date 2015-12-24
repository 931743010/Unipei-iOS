//
//  JPLazyBlock.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/10.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPLazyBlock : NSObject

-(void)excuteBlock:(dispatch_block_t)block;

@end
