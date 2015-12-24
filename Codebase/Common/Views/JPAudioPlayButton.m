//
//  JPAudioPlayButton.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/23.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPAudioPlayButton.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UnipeiApp-Swift.h>
#import "AudioAmrUtil.h"
#import "KLAudioManager.h"
#import "KLAudioRecorder.h"
#import "JPUtils.h"
#import "JPSubmitButton.h"
#import "NSMutableDictionary+Safety.h"

@interface JPAudioPlayButton () {
    UIImageView         *_ivAudio;
    UILabel             *_lblDuration;
    JPSubmitButton      *_btnAction;
    
    UILongPressGestureRecognizer *_longPressGest;
}

@end



@implementation JPAudioPlayButton

-(NSMutableDictionary *)infoDic {

    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    if (_isLocal && _localPath) {
        [infoDic setObject:@2 forKey:@"type"];
        [infoDic setObject:_localPath forKey:@"picpath"];
        [infoDic setObjectSafe:[_localPath lastPathComponent] forKey:@"picname"];
    } else if (_remotePath) {
        infoDic = [_remoteAudioInfo mutableCopy];
    }
    
    return infoDic;
}

-(void)setRemoteAudioInfo:(NSDictionary *)remoteAudioInfo {
    _remoteAudioInfo = remoteAudioInfo;
    
    self.remotePath = _remoteAudioInfo[@"picpath"];
}

-(BOOL)canPlay {
    return (_isLocal && _localPath) || _remotePath;
}

-(NSURL *)remoteURL {
    NSString *fullPath = [JPUtils fullMediaPath:_remotePath];
    return [NSURL URLWithString:fullPath];
}

-(void)setRemotePath:(NSString *)remotePath {
    _remotePath = remotePath;
    
    NSArray *strings = [_remotePath componentsSeparatedByString:@"/"];
    NSInteger duration = [[strings.lastObject componentsSeparatedByString:@"_"].firstObject integerValue];
    self.duration = duration;
    
    _isLocal = NO;
}

-(void)setLocalPath:(NSString *)localPath {
    _localPath = localPath;
    _isLocal = YES;
}

-(void)setDuration:(CGFloat)duration {

    _duration = duration;
    
    NSInteger durationInt = duration;
    durationInt = MAX(1, durationInt);
    _lblDuration.text = _duration > 0 ? [NSString stringWithFormat:@"%ld秒", (long)durationInt] : @"";
}

#pragma mark - life events
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit {
    
//    @weakify(self)
    
    ///
    _lblDuration = [UILabel new];
//    _lblDuration.text = @"30秒";
    _lblDuration.font = [UIFont systemFontOfSize:12];
    _lblDuration.textColor = [UIColor whiteColor];
    [self addSubview:_lblDuration];
    [_lblDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(-5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    _ivAudio = [UIImageView new];
    _ivAudio.image = [UIImage imageNamed:@"icon_voice_anim_3"];
    _ivAudio.animationImages = @[[UIImage imageNamed:@"icon_voice_anim_1"]
                                 , [UIImage imageNamed:@"icon_voice_anim_2"]
                                 , [UIImage imageNamed:@"icon_voice_anim_3"]];
    _ivAudio.animationDuration = 1;
    [self addSubview:_ivAudio];
    [_ivAudio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    
    _btnAction = [[JPSubmitButton alloc] initWithStyle:kJPButtonOrange];
    [self insertSubview:_btnAction atIndex:0];
    [_btnAction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [[_btnAction rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
        if ([KLAudioManager sharedInstance].state == STKAudioPlayerStatePlaying
            
            || [KLAudioManager sharedInstance].state == STKAudioPlayerStateBuffering) {
            
            NSString *currentPlayingURL = [KLAudioManager sharedInstance].currentPlayingURL;
            
            [[KLAudioManager sharedInstance] stop];
            
            if (![currentPlayingURL isEqualToString:_localPath]) {
                [self doPlay];
            }
            
        } else {
            [self doPlay];
        }
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStateChanged:) name:JP_NOTIFICATION_PLAYER_STATE_CHANGED object:nil];
    
    _longPressGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
}

-(void)longPressed:(UILongPressGestureRecognizer *)gest {
    if (gest.state == UIGestureRecognizerStateBegan) {
        if (_longPressBlock) {
            _longPressBlock(self);
        }
    }
}

-(void)setLongPressBlock:(JPAudioPlayButtonLongPressBlock)longPressBlock {
    _longPressBlock = [longPressBlock copy];
    if (_longPressBlock) {
        [_btnAction addGestureRecognizer:_longPressGest];
    } else {
        [_btnAction removeGestureRecognizer:_longPressGest];
    }
}

-(void)doPlay {
    
    if (_isLocal) {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:_localPath]) {
            
            [[KLAudioManager sharedInstance] playFileAt:_localPath];
        }
        
    } else if (_remotePath) {
        
        NSURL *fullURL = self.remoteURL;
        
        if ([fullURL.absoluteString.lowercaseString rangeOfString:@".amr"].location != NSNotFound) {
            
            [AudioAmrUtil asyncEncondeAmrToWave:fullURL completion:^(NSData *amrData, NSString *amrFile, EJPAudioFormat fmt) {
                _localPath = amrFile;
                [[KLAudioManager sharedInstance] playFileAt:amrFile];
            }];
            
        } else {
            
            // Dont know why, but 此mp3 不support流式播放，故先下载后播放
            //                @weakify(self)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *waveData = [NSData dataWithContentsOfURL:fullURL];
                
                // 如果没有取到数据，提示用户
                if (waveData == nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[JLToast makeTextQuick:@"语音地址无效, 无法播放"] show];
                    });
                    return;
                }
                
                ///
                NSArray *strings = [fullURL.absoluteString componentsSeparatedByString:@"/"];
                NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                NSString *filePath = [documentPath stringByAppendingPathComponent:strings.lastObject];
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                }
                
                [waveData writeToFile:filePath atomically:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _localPath = filePath;
                    [[KLAudioManager sharedInstance] playFileAt:filePath];
                });
            });
        }
    }
}


-(void)playerStateChanged:(id)sender {
    NSInteger state = [KLAudioManager sharedInstance].state;
    if (state == STKAudioPlayerStatePlaying) {
        
        NSString *currentPlayingURL = [KLAudioManager sharedInstance].currentPlayingURL;
        
        if ([currentPlayingURL isEqualToString:_localPath]) {
            NSTimeInterval duration = [KLAudioManager sharedInstance].duration;
            self.duration = duration;
            
            [_ivAudio startAnimating];
        } else {
            [_ivAudio stopAnimating];
        }
        
    } else if (state == STKAudioPlayerStateStopped || state == STKAudioPlayerStatePaused) {
        [_ivAudio stopAnimating];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
