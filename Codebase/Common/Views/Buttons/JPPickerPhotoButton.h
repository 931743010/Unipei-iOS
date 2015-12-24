//
//  JPPickerPhotoButton.h
//  DymIOSApp
//
//  Created by MacBook on 11/5/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JPPickerStatus) {
    kJPPickerEmpty     = 0     // 空图片状态
    , kJPPickerLocal   = 1     // 本地图片
    , kJPPickerRemote  = 2     // 远程图片
 
};

@interface JPPickerPhotoButton : UIButton
{
       UIImage     *_defaultImage;
}

@property(nonatomic,copy) NSString *remotePath;
@property(nonatomic,retain) UIImage *localImage;
@property(nonatomic,readonly) JPPickerStatus status;

@property(nonatomic,retain) NSDictionary *remoteInfo;  //用于保存远程图片数据

@end
