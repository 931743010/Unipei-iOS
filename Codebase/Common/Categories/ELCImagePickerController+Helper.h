//
//  ELCImagePickerController+Helper.h
//  DymIOSApp
//
//  Created by MacBook on 11/4/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface ELCImagePickerController (Helper)

+(BOOL)authorizationStatus;
+(BOOL)canUseCamera;
+(BOOL)canUsePhotoLibrary;
+(BOOL)canTakePicture;


//+(void)pickImageWithDelegate:(id)delegate presentingVC:(UIViewController *)presentingVC;

+(void)pickImageWithDelegate:(id)delegate
                presentingVC:(UIViewController *)presentingVC
           withMaxPhotoCount:(NSUInteger) maxPhotoCount
             currentCount:(NSUInteger) currentCount ;

+ (UIImage *)savePickingMediaWithInfo:(NSDictionary *)info;


@end
