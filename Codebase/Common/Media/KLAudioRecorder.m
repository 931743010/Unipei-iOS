//
//  KLAudioRecorder.m
//  TestRecord
//
//  Created by Dong Yiming on 8/24/14.
//  Copyright (c) 2014 HuiYan. All rights reserved.
//

#import "KLAudioRecorder.h"
#import "KLAudioManager.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPUtils.h"

static const DDLogLevel ddLogLevel = DDLogLevelDebug;

#define SAMPLE_RATE     (8000.f) //(11025.f)  // (44100.f)

@interface KLAudioRecorder () <AVAudioRecorderDelegate> {
    NSDate * __startDate;
    NSDate * __endDate;

}
@property (nonatomic, strong) AVAudioRecorder           *audioRecorder;
@property (nonatomic, copy) RecordStoppedCallback       stoppedCallback;


@end

@implementation KLAudioRecorder

+(instancetype)sharedInstance {
    static KLAudioRecorder *instance = nil;
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
        /* Ask for permission to see if we can record audio */
        
        
        
        /// init recorder
        [self recreateRecorder];
    }
    return self;
}

-(double)getPeakPower{
    if (_audioRecorder) {
        [_audioRecorder updateMeters];
    }
    
    float peakPower = [_audioRecorder averagePowerForChannel:0];
//    DDLogDebug(@"peak Power:%f",peakPower);
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    
    return peakPowerForChannel;
}

-(void)recreateRecorder {
    _audioRecorder.delegate = nil;
    _audioRecorder = nil;
    NSError *error = nil;
    
    NSURL *audioRecordingURL = [self audioFileURL];
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:audioRecordingURL
                      settings:[self audioRecordingSettings]
                      error:&error];
    _audioRecorder.delegate = self;
    _audioRecorder.meteringEnabled = YES;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
                   error:nil];
    [session setActive:YES error:nil];
    [session requestRecordPermission:^(BOOL granted) {
        _enabled = granted;
    }];
}


- (NSURL *) audioFileURL {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *documentsFolderUrl = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask
                                           appropriateForURL:nil create:NO error:nil];
    return [documentsFolderUrl URLByAppendingPathComponent:@"recording.caf"];
}

-(NSString *)audioFilePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"recording.caf"];
}

- (NSDictionary *) audioRecordingSettings{
    return @{ AVFormatIDKey : @(kAudioFormatLinearPCM) //@(kAudioFormatLinearPCM)
              , AVSampleRateKey : @(SAMPLE_RATE)
              , AVNumberOfChannelsKey : @1
//              , AVEncoderAudioQualityKey : @(AVAudioQualityMax)
              , AVLinearPCMBitDepthKey : @(16)
              , AVLinearPCMIsNonInterleaved : @(NO)
              , AVLinearPCMIsFloatKey : @(NO)
              , AVLinearPCMIsBigEndianKey : @(NO)};
}

#pragma mark - actions
-(BOOL)start {
    if (_enabled && !_recording) {
        
        //[SharedAudioManager stop];
        [self recreateRecorder];
        
        if ([self.audioRecorder record]) {
            DDLogDebug(@"Successfully started to record.");
            _recording = YES;
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            
            __startDate =[NSDate date];
            
            return YES;
            
        } else {
            DDLogDebug(@"Failed started to record!");
        }
        
    } else {
        DDLogDebug(@"Recorder is recording or not enabled");
        if (!_enabled) {
            [JPUtils showAlert:@"无法录音" message:@"请在iPhone的\"设置-隐私-麦克风\"选项中，允许\"由你配\"访问你的手机麦克风。" confirmTitle:@"确认"];
        }
    }
    
    return NO;
}

-(void)stop {
    [_audioRecorder stop];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
}

-(void)stop:(RecordStoppedCallback)completion {
    
    self.stoppedCallback = completion;
    [self stop];
}


#pragma mark -
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    _recording = !flag;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    __endDate=[NSDate date];
    
    DDLogDebug(@"Record stopped: %d", _recording);
    if (self.stoppedCallback) {
        self.stoppedCallback([self audioFilePath],[__endDate timeIntervalSince1970]-[__startDate timeIntervalSince1970], flag);
        self.stoppedCallback = nil;
        __startDate=nil;
        __endDate=nil;
    }
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    DDLogDebug(@"Recording process is interrupted");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags {
    if (flags == AVAudioSessionInterruptionOptionShouldResume) {
        DDLogDebug(@"Resuming the recording...");
        [recorder record];
    }
}



@end
