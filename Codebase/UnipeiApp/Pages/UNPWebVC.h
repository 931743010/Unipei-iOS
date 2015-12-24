//
//  GNWebVC.h
//  GageinNew
//
//  Created by Dong Yiming on 3/12/14.
//  Copyright (c) 2014 Gagein. All rights reserved.
//

#import "DymBaseVC.h"

@interface UNPWebVC : DymBaseVC

-(instancetype)initWithUrl:(NSString *)aURL naviTitle:(NSString *)aNaviTitle;

@property (copy) NSString *urlStr;
@property (copy) NSString *naviTitle;
@property (assign, nonatomic) BOOL showUrlBar;

@end
