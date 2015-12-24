//
//  AudioAmrUtil.h
//  audiodemo
//
//  Created by sumeng on 7/28/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EJPAudioFormat) {
    kJPAudioFormatWave
    , kJPAudioFormatAmr
};

typedef void(^AudioConvertCompletionBlock)(NSData *amrData, NSString *amrFile, EJPAudioFormat fmt);
typedef void(^AudiosConvertCompletionBlock)(NSArray *amrDatas, NSArray *amrFiles, EJPAudioFormat fmt);

@interface AudioAmrUtil : NSObject

+(void)asyncEncondeWaveToAmr:(NSString *)waveFile completion:(AudioConvertCompletionBlock)completion;

+ (NSString *)encodeWaveToAmr:(NSString *)waveFile;
+ (NSString *)encodeWaveToAmr:(NSString *)waveFile
                  nChannels:(int)nChannels
             nBitsPerSample:(int)nBitsPerSample;


+(void)asyncEncondeAmrToWave:(NSURL *)amrFile completion:(AudioConvertCompletionBlock)completion;
/// 批量转换
+(void)asyncEncondeWavesToAmrs:(NSArray *)localWaveFileDics completion:(AudiosConvertCompletionBlock)completion;

+ (NSString *)decodeAmrToWave:(NSString *)amrFile;

/// amr文件名
+ (NSString *)amrFilenameConvertedFrom:(NSString *)waveFile;
/// wave文件名
+ (NSString *)waveFilenameConvertedFrom:(NSString *)amrFile;

/// 清除所有转换文件
+ (BOOL)cleanCache;

+ (NSString *)convertDir;

@end
