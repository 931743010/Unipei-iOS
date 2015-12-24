//
//  UIImagePickerController+Helper.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/1.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UIImagePickerController+Helper.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>


@implementation UIImagePickerController (Helper)

+(BOOL)canUseCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+(BOOL)canUsePhotoLibrary {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+(BOOL)canTakePicture {
    
    if (![self canUseCamera]) {
        return NO;
    }
    
    NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];

    for (NSString* mediaType in availableMediaTypes) {
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
            return YES;
        }
    }
    
    return NO;
}


+(void)pickImageWithDelegate:(id)delegate presentingVC:(UIViewController *)presentingVC {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:@"选择需要上传的照片" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController canTakePicture]) {
            
            if ([self checkAlbumAuthorization] && [self checkCameraAuthorizationStatus] ){  //如果同时不能访问相机和相册不允许继续进行
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = delegate;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.mediaTypes = @[(NSString*)kUTTypeImage];
                picker.allowsEditing = YES;  
                [presentingVC presentViewController:picker animated:YES completion:nil];
            }else{
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权使用" message:@"请在iOS '设置-隐私' 中允许'由你配'同时访问你的'照片'和'相机'。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alertView show];
            }
            
           
        }
    }];
    
    UIAlertAction *pickFromLibrary = [UIAlertAction actionWithTitle:@"选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController canUsePhotoLibrary]) {
            if ([self checkAlbumAuthorization] ){
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.mediaTypes = @[(NSString*)kUTTypeImage];
                picker.allowsEditing = YES;
                
                picker.delegate = delegate;
                [presentingVC presentViewController:picker animated:YES completion:nil];
            }else{
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权使用" message:@"请在iOS '设置-隐私' 中允许'由你配'访问你的'照片'。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alertView show];
            }
            
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:takePicture];
    [alertController addAction:pickFromLibrary];
    [alertController addAction:cancel];
    
    [presentingVC presentViewController:alertController animated:YES completion:nil];
}


+ (UIImage *)savePickingMediaWithInfo:(NSDictionary *)info {
    
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {  //public.image
        
        UIImage *resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];;
        
        if([self checkAlbumAuthorization]){  //在禁止访问相册时出现照片保存异常.允许才保存
            CGRect cropRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
            
            if (cropRect.origin.x != 0 || cropRect.origin.y != 0
                || cropRect.size.width != resultImage.size.width
                || cropRect.size.height != resultImage.size.height) {
                
                // image has been edited
                resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
                UIImageWriteToSavedPhotosAlbum(resultImage, nil, NULL, NULL);
            }
        }
        
        return resultImage;
    }
    //       }
    
    
    return nil;
}

//相册权限检测
+(BOOL) checkAlbumAuthorization{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status) {
        case ALAuthorizationStatusNotDetermined: {
            return NO;
            break;
        }
        case ALAuthorizationStatusRestricted: {
            return NO;
            break;
        }
        case ALAuthorizationStatusDenied: {
            return NO;
            break;
        }
        case ALAuthorizationStatusAuthorized: {
            return YES;
            break;
        }
        default: {
            return NO;
            break;
        }
    }
}

//相机拍照权限检测
+(BOOL) checkCameraAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

@end
