//
//  KLAudioRecorder.h
//  TestRecord
//
//  Created by Dong Yiming on 8/24/14.
//  Copyright (c) 2014 HuiYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^RecordStoppedCallback)(NSString *filePath,long long duration, BOOL successfully);


///
@interface KLAudioRecorder : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, readonly) BOOL        enabled;
@property (nonatomic, readonly) BOOL        recording;

-(BOOL)start;
-(void)stop:(RecordStoppedCallback)completion;
-(double)getPeakPower;

- (NSURL *) audioFileURL;
-(NSString *)audioFilePath;

@end


