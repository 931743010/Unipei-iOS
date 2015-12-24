//
//  AudioAmrUtil.m
//  audiodemo
//
//  Created by sumeng on 7/28/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "AudioAmrUtil.h"
#import "amrFileCodec.h"
#import "NSString+GGAddOn.h"

@implementation AudioAmrUtil

+(void)asyncEncondeWavesToAmrs:(NSArray *)localWaveFileDics completion:(AudiosConvertCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSMutableArray *datas = [NSMutableArray array];
        NSMutableArray *filePaths = [NSMutableArray array];
        
        for (id fileDic in localWaveFileDics) {
            NSString *waveFile = fileDic[@"picpath"];
            
            NSData *amrData = [self dataEncodeWaveToAmr:waveFile nChannels:1 nBitsPerSample:16];
            
            NSString *amrFile = [self amrFilenameConvertedFrom:waveFile];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:amrFile]) {
                [[NSFileManager defaultManager] removeItemAtPath:amrFile error:nil];
            }
            
            [amrData writeToFile:amrFile atomically:YES];
            
            if (amrData && amrFile) {
                [datas addObject:amrData];
                [filePaths addObject:amrFile];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(datas, filePaths, kJPAudioFormatAmr);
            }
        });
    });
}

+(void)asyncEncondeWaveToAmr:(NSString *)waveFile completion:(AudioConvertCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *amrData = [self dataEncodeWaveToAmr:waveFile nChannels:1 nBitsPerSample:16];
        
        NSString *amrFile = [self amrFilenameConvertedFrom:waveFile];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:amrFile]) {
            [[NSFileManager defaultManager] removeItemAtPath:amrFile error:nil];
        }
        
        [amrData writeToFile:amrFile atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(amrData, amrFile, kJPAudioFormatAmr);
            }
        });
    });
}

+ (NSString *)encodeWaveToAmr:(NSString *)waveFile {
    return [self encodeWaveToAmr:waveFile nChannels:1 nBitsPerSample:16];
}

+ (NSString *)encodeWaveToAmr:(NSString *)waveFile
                    nChannels:(int)nChannels
               nBitsPerSample:(int)nBitsPerSample {
    
    NSData *amrData = [self dataEncodeWaveToAmr:waveFile nChannels:nChannels nBitsPerSample:nBitsPerSample];
    
    NSString *amrFile = [self amrFilenameConvertedFrom:waveFile];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:amrFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:amrFile error:nil];
    }
    
    [amrData writeToFile:amrFile atomically:YES];
    return amrFile;
}

+ (NSData *)dataEncodeWaveToAmr:(NSString *)waveFile
                    nChannels:(int)nChannels
               nBitsPerSample:(int)nBitsPerSample {
    
    if (waveFile == nil) {
        return nil;
    }
    
    NSData *amrData = EncodeWAVEToAMR([NSData dataWithContentsOfFile:waveFile], nChannels, nBitsPerSample);
    
    return amrData;
}



#pragma mark - amr to wave

+(void)asyncEncondeAmrToWave:(NSURL *)amrFileURL completion:(AudioConvertCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *waveData = DecodeAMRToWAVE([NSData dataWithContentsOfURL:amrFileURL]);
        
        NSString *waveFile = [self waveFilenameConvertedFrom:amrFileURL.absoluteString];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:waveFile]) {
            [[NSFileManager defaultManager] removeItemAtPath:waveFile error:nil];
        }
        
        [waveData writeToFile:waveFile atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(waveData, waveFile, kJPAudioFormatWave);
            }
        });
    });
}

+ (NSString *)decodeAmrToWave:(NSString *)amrFile {
    if (amrFile == nil) {
        return nil;
    }
    
    NSData *waveData = DecodeAMRToWAVE([NSData dataWithContentsOfFile:amrFile]);
    
    NSString *waveFile = [self waveFilenameConvertedFrom:amrFile];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:waveFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:waveFile error:nil];
    }
    
    [waveData writeToFile:waveFile atomically:YES];
    
    return waveFile;
}


#pragma mark -
+ (NSString *)amrFilenameConvertedFrom:(NSString *)waveFile {
    return [[[self convertDir] stringByAppendingPathComponent:[waveFile lastPathComponent]] stringByAppendingPathExtension:@"amr"];
}

+ (NSString *)waveFilenameConvertedFrom:(NSString *)amrFile {
    return [[[self convertDir] stringByAppendingPathComponent:[amrFile lastPathComponent]] stringByAppendingPathExtension:@"wav"];
}

+ (NSString *)convertDir {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dir = [docDir stringByAppendingPathComponent:@"AudioConvert"];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
    return dir;
}

+ (BOOL)cleanCache {
    return [[NSFileManager defaultManager] removeItemAtPath:[self convertDir] error:nil];
}

@end
