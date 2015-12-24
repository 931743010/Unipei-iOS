//
//  KLAudioManager.h
//  keluapp
//
//  Created by Dong Yiming on 8/9/14.
//  Copyright (c) 2014 HuiYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StreamingKit/STKAudioPlayer.h>



@interface KLAudioManager : NSObject

+(instancetype)sharedInstance;

@property (nonatomic,strong)NSString * lastRecordPath;
@property (nonatomic,assign)long long lastRecordDuration;

-(void)playUrlAt:(NSString *)aURL;
-(void)playFileAt:(NSString *)aFilePath;

-(void)pause;
-(void)resume;
-(void)stop;
-(NSString *)currentPlayingURL;

-(double)duration;
-(double)progress;
-(STKAudioPlayerState)state;

@end

