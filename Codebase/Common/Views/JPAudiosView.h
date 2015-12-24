//
//  JPAudiosView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPAudiosView : UIView

@property (nonatomic, strong, readonly) NSArray *localAudios;

@property (nonatomic, strong, readonly) NSArray *remoteAudios;

@property (nonatomic, copy) dispatch_block_t    contentHeightChangedBlock;

@property (nonatomic, assign) BOOL              isRecordingEnabled;

@property (nonatomic, assign) NSInteger         maxAudioCount;

-(void)setAudioURLs:(NSArray *)audioURLs;

-(void)removeButton:(id)button;

-(void)stopRecordAndRefresh;

@end
