//
//  JPAudioPlayButton.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/23.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPAudioPlayButton;

typedef void(^JPAudioPlayButtonLongPressBlock)(JPAudioPlayButton *whichButton);

@interface JPAudioPlayButton : UIView
/// 服务端audio url
@property (nonatomic, copy, readonly) NSURL        *remoteURL;
/// 本地audio url, 非full path, 截取到/server/
@property (nonatomic, copy, readonly) NSString     *remotePath;
/// 传入参数，server audio info
@property (nonatomic, strong) NSDictionary          *remoteAudioInfo;
/// 本地录音文件路径
@property (nonatomic, copy) NSString                *localPath;
/// 录音时长
@property (nonatomic, assign) CGFloat               duration;
/// 是否可播放
@property (nonatomic, assign) BOOL                  canPlay;
/// 是用本地还是服务端audio数据
@property (nonatomic, assign, readonly) BOOL        isLocal;
/// 长按事件处理
@property (nonatomic, copy) JPAudioPlayButtonLongPressBlock        longPressBlock;


-(NSMutableDictionary *)infoDic;


@end
