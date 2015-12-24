//
//  UIImagePickerController+Helper.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/1.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UIImagePickerController (Helper)

+(BOOL)canUseCamera;
+(BOOL)canUsePhotoLibrary;
+(BOOL)canTakePicture;

+(void)pickImageWithDelegate:(id)delegate presentingVC:(UIViewController *)presentingVC;

+ (UIImage *)savePickingMediaWithInfo:(NSDictionary *)info;

@end
