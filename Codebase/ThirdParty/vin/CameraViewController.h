//
//  CameraViewController.h
//
//  Created by etop on 15/10/22.
//  Copyright (c) 2015年 etop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>

@class CameraViewController;
@protocol CameraDelegate <NSObject>

@required
//vin码初始化结果，判断核心是否初始化成功
- (void)initVinTyperWithResult:(int)nInit;

@optional
//相机视图将要显示时回调此方法，返回相机视图控制器
- (void)viewWillAppearWithCameraViewController:(CameraViewController *)cameraVC;

//相机视图已经显示时回调此方法，返回相机视图控制器
- (void)viewDidAppearWithCameraViewController:(CameraViewController *)cameraVC;

//相机视图将要消失时回调此方法，返回相机视图控制器
- (void)viewWillDisappearWithCameraViewController:(CameraViewController *)cameraVC;

//相机视图已经消失时回调此方法，返回相机视图控制器
- (void)viewDidDisappearWithCameraViewController:(CameraViewController *)cameraVC;

@end

@interface CameraViewController : UIViewController
@property (assign, nonatomic) id<CameraDelegate>delegate;
@property(strong, nonatomic) UIImage *resultImg;
@property (copy, nonatomic) NSString *nsCompanyName; //公司名称
@property (copy, nonatomic) NSString *vinResult; //识别结果
@property (copy, nonatomic) NSString *scanType; //识别类型
@end
