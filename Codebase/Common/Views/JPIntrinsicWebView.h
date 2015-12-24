//
//  JPIntrinsicWebView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/4.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPIntrinsicWebView : UIView

@property (nonatomic, copy) dispatch_block_t    contentLoadedBlock;

-(void)loadPlainText:(NSString *)plainText;

-(void)loadURL:(NSString *)url;


@end
