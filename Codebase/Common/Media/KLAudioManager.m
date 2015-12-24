//
//  KLAudioManager.m
//  keluapp
//
//  Created by Dong Yiming on 8/9/14.
//  Copyright (c) 2014 HuiYan. All rights reserved.
//

#import "KLAudioManager.h"
#import "SampleQueueId.h"
#import "JPUtils.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static const DDLogLevel ddLogLevel = DDLogLevelDebug;


@interface KLAudioManager () <STKAudioPlayerDelegate> {
    STKAudioPlayer  *_player;

}

@end

@implementation KLAudioManager

+(instancetype)sharedInstance {
    static KLAudioManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = [STKAudioPlayer new];
        _player.delegate = self;
    }
    return self;
}

-(void)playUrlAt:(NSString *)aURL {
    
    DDLogDebug(@"play audio url: %@", aURL);
    
    [_player play:aURL];
}

-(void)playFileAt:(NSString *)aFilePath {
    DDLogDebug(@"play audio file: %@", aFilePath);
    
	NSURL* url = [NSURL fileURLWithPath:aFilePath];
	STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
	
	[_player setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
    
}


-(void)pause {
    [_player pause];
}

-(void)resume {
    [_player resume];
}

-(void)stop {
    [_player stop];
}

-(STKAudioPlayerState)state {
    return _player.state;
}

-(double)duration {
    return _player.duration;
}

-(double)progress {
    return _player.progress;
}

-(NSString *)currentPlayingURL {
    id currentPlayingItem = [_player currentlyPlayingQueueItemId];
    if ([currentPlayingItem isKindOfClass:[SampleQueueId class]]) {
        return ((SampleQueueId *)currentPlayingItem).url.relativePath;
    } else if ([currentPlayingItem isKindOfClass:[NSString class]]) {
        return currentPlayingItem;
    }
    
    return nil;
}


#pragma mark - STKAudioPlayerDelegate

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId {
    
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId {
    
}


-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {

    switch (state) {
        case STKAudioPlayerStateReady:
            DDLogDebug(@"STKAudioPlayerStateReady");
            break;
            
        case STKAudioPlayerStateRunning:
            DDLogDebug(@"STKAudioPlayerStateRunning");
            break;
            
        case STKAudioPlayerStatePlaying:
            DDLogDebug(@"STKAudioPlayerStatePlaying");
            [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_STK_AUDIO_PLAYING object:nil];
            break;
            
        case STKAudioPlayerStateBuffering:
            DDLogDebug(@"STKAudioPlayerStateBuffering");
            [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_STK_AUDIO_BUFFERING object:nil];
            break;
            
        case STKAudioPlayerStatePaused:
            DDLogDebug(@"STKAudioPlayerStatePaused");
            [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_STK_AUDIO_PAUSED object:nil];

            break;
            
        case STKAudioPlayerStateStopped:
            DDLogDebug(@"STKAudioPlayerStateStopped");
            [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_STK_AUDIO_STOPPED object:nil];
            break;
            
        case STKAudioPlayerStateError:
            DDLogDebug(@"STKAudioPlayerStateError");
            break;
            
        case STKAudioPlayerStateDisposed:
            DDLogDebug(@"STKAudioPlayerStateDisposed");
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_PLAYER_STATE_CHANGED object:nil];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    
}

@end
