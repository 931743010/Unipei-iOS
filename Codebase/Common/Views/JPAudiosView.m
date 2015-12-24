//
//  JPAudiosView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPAudiosView.h"
#import "JPAudioPlayButton.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UnipeiApp-Swift.h>
#import "AudioAmrUtil.h"
#import "KLAudioManager.h"
#import "KLAudioRecorder.h"
#import "JPUtils.h"
#import "JPDesignSpec.h"

#define BUTTON_GAP  (8)
#define BUTTON_HEIGHT  (38)
#define DEFUALT_MAX_AUDIO_COUNT  (5)

@interface JPAudiosView () {
    NSMutableArray      *_audioButtons;
    
    UIButton             *_btnRecord;
    CGFloat             _recordingDuration;
    BOOL                _isRecording;
    
    CGFloat                 _intrinsicHeight;
    
    UIView                  *_recordingHUD;
    UIImageView             *_ivRecodingAnimation;
    NSMutableArray          *_recordingAnimationFrames;
    NSInteger               _frameCount;
    id<NSObject>            _recordingObserver;
    NSInteger               _recordSerialNumber;
    
    
    JPAudioPlayButtonLongPressBlock     _longPressBlock;
}

@property (nonatomic, copy) NSArray *audioURLs;

@end



@implementation JPAudiosView

-(void)dealloc {
    
    [self hideRecordingHUD];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit {
    _maxAudioCount = DEFUALT_MAX_AUDIO_COUNT;
    _frameCount = 14;
    _audioButtons = [NSMutableArray array];
    
    /// recording animation
    _recordingHUD = [UIView new];
    _recordingHUD.backgroundColor = [UIColor colorWithWhite:0 alpha:0.54];
    _recordingHUD.layer.cornerRadius = 5;
    [_recordingHUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    _ivRecodingAnimation = [UIImageView new];
    [_recordingHUD addSubview:_ivRecodingAnimation];
    [_ivRecodingAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@38);
        make.height.equalTo(@56);
        make.centerX.equalTo(_recordingHUD.mas_centerX);
        make.centerY.equalTo(_recordingHUD.mas_centerY);
    }];
    
    _recordingAnimationFrames = [NSMutableArray arrayWithCapacity:_frameCount];
    for (NSInteger i = 0; i < _frameCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"record_animate_%02ld", (long)(i + 1)];
        UIImage *frame = [UIImage imageNamed:imageName];
        if (frame) {
            [_recordingAnimationFrames addObject:frame];
        }
    }
    _ivRecodingAnimation.image = _recordingAnimationFrames.firstObject;
    
    
    ///
    @weakify(self)
    _longPressBlock = ^(JPAudioPlayButton *theBtn) {
        
        @strongify(self)
        [[KLAudioManager sharedInstance] stop];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否删除这段语音?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        @weakify(self)
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            @strongify(self)
            [self removeButton:theBtn];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ok];
        [alertController addAction:cancel];
        [[JPUtils topMostVC] presentViewController:alertController animated:YES completion:nil];
    };

    
    ///
    _btnRecord = [UIButton new];
    [_btnRecord setTitle:@"按住录音" forState:UIControlStateNormal];
    [_btnRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnRecord.titleLabel.font = [UIFont systemFontOfSize:14];
    _btnRecord.layer.cornerRadius = 4;
    _btnRecord.layer.borderColor = [JPDesignSpec colorSilver].CGColor;
    _btnRecord.layer.borderWidth = 0.5;
    _btnRecord.backgroundColor = [JPDesignSpec colorWhiteDark];
    
    ///
    [[_btnRecord rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        @strongify(self)
        if ([self reachedRecordLimit]) {
            NSString *message = [NSString stringWithFormat:@"最多只能录%ld段语音", (long)_maxAudioCount];
            [[JLToast makeText:message] show];
            return;
        }
        
        [[KLAudioManager sharedInstance] stop];
        BOOL startOK = [[KLAudioRecorder sharedInstance] start];
        if (startOK) {
            self->_recordingDuration = 0;
            self->_isRecording = YES;
            
            [self showRecordingHUD];
        }
    }];
    
    [_btnRecord addTarget:self action:@selector(handleBtnRecordTouchUpInside) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
//    [_btnRecord addTarget:self action:@selector(handleBtnRecordTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
//    [[_btnRecord rac_signalForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside] subscribeNext:^(id x) {
//        
//        @strongify(self)
//        [self stopRecordAndRefresh];
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTimeTick:) name:JP_NOTIFICATION_GLOBAL_TIME_TICK object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRecordAndRefresh) name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)handleBtnRecordTouchUpInside {
    [self stopRecordAndRefresh];
}

-(void)handleBtnRecordTouchUpOutside {
    [self stopRecordAndRefresh];
}

-(void)stopRecordAndRefresh {
    @weakify(self)
    
    [self hideRecordingHUD];
    
    if (![KLAudioRecorder sharedInstance].recording) {
        self->_isRecording = NO;
        return;
    }
    
    [[KLAudioRecorder sharedInstance] stop:^(NSString *filePath, long long duration, BOOL successfully) {
        @strongify(self)
        self->_recordingDuration = 0;
        self->_isRecording = NO;
        
        if (duration > 1.0) {
            NSString *randomStr = [JPUtils randomDigitString];
            
            NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
            dateFmt.dateFormat = @"yyyyMMddhhmmss";
            NSString *dateStr = [dateFmt stringFromDate:[NSDate date]];
            
            NSString *finalFileName = [NSString stringWithFormat:@"%ld_%@_%@%03ld.caf", (long)duration, randomStr, dateStr, (long)_recordSerialNumber];
            NSString *finalFilePath = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:finalFileName];
            
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:finalFilePath error:&error];
            if (!error) {
                [self appendLocalFilePath:finalFilePath duration:duration];
                [self updateRecordButtonVisibility];
                self->_recordSerialNumber++;
            }
        } else {
            [[JLToast makeTextQuick:@"录音时间太短，请重录"] show];
        }
    }];
}

-(void)handleTimeTick:(NSNotification *)notification {

    if (!_isRecording) {
        return;
    }
    
    NSNumber *tickInterval = notification.object;
    _recordingDuration += [tickInterval floatValue];
    
    if (_recordingDuration > 60) {
        [self stopRecordAndRefresh];
        
        [[JLToast makeText:@"录音时长达到60秒上限"] show];
    }
}

-(void)updateRecordButtonVisibility {
    _btnRecord.hidden = [self reachedRecordLimit];
}

-(BOOL)reachedRecordLimit {
    return (_audioButtons.count - 1 >= _maxAudioCount);
}

-(void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - properties
-(NSArray *)localAudios {
    NSMutableArray *audios = [NSMutableArray arrayWithCapacity:_audioButtons.count];
    [_audioButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[JPAudioPlayButton class]]) {
            JPAudioPlayButton *btn = obj;
            if (btn.isLocal && [[btn infoDic] isKindOfClass:[NSMutableDictionary class]]) {
                [audios addObject:[btn infoDic]];
            }
        }
    }];
    
    return audios;
}

-(NSArray *)remoteAudios {
    NSMutableArray *audios = [NSMutableArray arrayWithCapacity:_audioButtons.count];
    [_audioButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[JPAudioPlayButton class]]) {
            JPAudioPlayButton *btn = obj;
            if (!(btn.isLocal) && [[btn infoDic] isKindOfClass:[NSMutableDictionary class]]) {
                [audios addObject:[btn infoDic]];
            }
        }
    }];
    
    return audios;
}


//(
//{
//    id = 3507;
//    inquiryid = 2004;
//    picname = "4.499998_81f440a60d5a7047_201510231053464.amr";
//    picpath = "/servicer/inquiry/audio/20151023/4.499998_81f440a60d5a7047_201510231053464.amr";
//    type = 2;
//}
// )

-(NSArray *)sortedAudioInfos:(NSArray *)audioInfos {
    return [audioInfos sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *picname1 = [obj1[@"picname"] componentsSeparatedByString:@"."].firstObject;
        NSString *picname2 = [obj2[@"picname"] componentsSeparatedByString:@"."].firstObject;
        
        picname1 = [picname1 componentsSeparatedByString:@"_"].lastObject;
        picname2 = [picname2 componentsSeparatedByString:@"_"].lastObject;
        
        return [picname1 longLongValue] > [picname2 longLongValue];
    }];
}

-(void)setAudioURLs:(NSArray *)audioURLs {
    _audioURLs = [self sortedAudioInfos:audioURLs];
    
    [self recreateButtons];
    [self reinstallButtons];
}

#pragma mark - layout
-(void)appendLocalFilePath:(NSString *)localFilePath duration:(long long)duration {
    
    [_audioButtons makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    JPAudioPlayButton *audioButton = [JPAudioPlayButton new];
    audioButton.localPath = localFilePath;
    audioButton.duration = duration;
    if (_isRecordingEnabled) {
        audioButton.longPressBlock = _longPressBlock;
    }
    
    id lastButton = _audioButtons.lastObject;
    BOOL hasRecordButton = ![lastButton isKindOfClass:[JPAudioPlayButton class]];
    if (hasRecordButton) {
        [_audioButtons removeObject:lastButton];
    }
    
    [_audioButtons addObject:audioButton];
    
    if (hasRecordButton) {
        [_audioButtons addObject:lastButton];
    }
    
    [self reinstallButtons];
}

-(void)removeButton:(id)button {
    
    [_audioButtons makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    [_audioButtons removeObject:button];
    
    [self updateRecordButtonVisibility];
    
    [self reinstallButtons];
}

-(void)recreateButtons {
    [_audioButtons makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [_audioButtons removeAllObjects];
    
    NSInteger buttonsTotal = _isRecordingEnabled ? _audioURLs.count + 1 : _audioURLs.count;
    
    for (NSInteger i = 0; i < buttonsTotal; i++) {
        
        UIView *newButton;
        
        if (i < _audioURLs.count) {
            JPAudioPlayButton *audioButton = [JPAudioPlayButton new];
            
            id remotePathDic = _audioURLs[i];
            audioButton.remoteAudioInfo = remotePathDic;
            
            if (_isRecordingEnabled) {
                audioButton.longPressBlock = _longPressBlock;
            }
            
            newButton = audioButton;
        } else {
            newButton = _btnRecord;
        }
        
        [_audioButtons addObject:newButton];
    }
}


-(void)reinstallButtons {
    
    UIView *lastButton;
    
    NSInteger buttonsTotal = _audioButtons.count;
    
    for (NSInteger i = 0; i < buttonsTotal; i++) {
        
        UIView *newButton = _audioButtons[i];
        [self addSubview:newButton];
        [newButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(BUTTON_HEIGHT));
            if (i % 2 == 0 || lastButton == nil) {
                make.leading.equalTo(self.mas_leading);
            } else {
                make.leading.equalTo(lastButton.mas_trailing).offset(BUTTON_GAP);
            }
            
            if (lastButton == nil) {
                make.top.equalTo(self.mas_top);
            } else if (i % 2 == 0) {
                make.top.equalTo(lastButton.mas_bottom).offset(BUTTON_GAP);
            } else {
                make.top.equalTo(lastButton.mas_top);
            }
            
            make.width.equalTo(self.mas_width).offset(-BUTTON_GAP * 0.5).multipliedBy(0.5);
        }];
        
        lastButton = newButton;
    }
    
    [self updateRecordButtonVisibility];
    
    [self invalidateIntrinsicContentSize];
}

-(CGSize)intrinsicContentSize {
    
    NSInteger lineCount = _audioButtons.count / 2;
    if (_audioButtons.count % 2) {
        lineCount ++;
    }
    
    CGFloat height = lineCount * BUTTON_HEIGHT + (lineCount - 1) * BUTTON_GAP;
    
    if (_intrinsicHeight != height) {
        _intrinsicHeight = height;
        
        if (_contentHeightChangedBlock) {
            _contentHeightChangedBlock();
        }
    }
    
    return CGSizeMake(UIViewNoIntrinsicMetric, height <= 0 ? 40 : height);
}

#pragma mark - recording hud
-(void)showRecordingHUD {
    UIWindow *window = self.window;
    [window addSubview:_recordingHUD];
    [_recordingHUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY).offset(-50);
    }];
    
    
    _recordingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:JP_NOTIFICATION_GLOBAL_TIME_TICK object:nil queue:nil usingBlock:^(NSNotification *note) {
        CGFloat peak = [[KLAudioRecorder sharedInstance] getPeakPower];
        
        NSInteger index = peak * _frameCount * 3; //amplified by 2
        index = MIN(index, _frameCount - 1);
        
//        DDLogDebug(@"peak:%f, index:%ld", peak, (long)index);
        _ivRecodingAnimation.image = _recordingAnimationFrames[index];
    }];
}

-(void)hideRecordingHUD {
    [_recordingHUD removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:_recordingObserver];
    _recordingObserver = nil;
}

@end
