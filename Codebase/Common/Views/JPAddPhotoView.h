//
//  JPAddPhotoView.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/8.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import "JPPickerPhotoButton.h"

@interface JPAddPhotoView : UIView
{
    
    NSMutableArray      *_localPhotos;  //本地选择的图片按钮
    NSMutableArray      *_remotePhotos; //远程下载的图片按钮
    
    JPPickerPhotoButton *_plusBtn;      //plus Button的删除引用
}


@property (nonatomic, assign) NSUInteger                    maxPhotoCount;
/// 一行显示几个图片
@property (nonatomic, assign) NSUInteger                    numOfImagesPerRow;
@property (nonatomic, weak) UIViewController                *presentingVC;
@property (nonatomic, assign) CGFloat                       buttonSize;
@property (nonatomic, assign) CGFloat                       buttonGap;

//@property (nonatomic, copy, readonly) NSArray                       *pickedPhotos;
//@property (nonatomic, copy, readonly) NSArray                       *allPhotos;
//@property (nonatomic, strong) NSMutableArray                          *picfilepList;
//@property (nonatomic, copy, readonly) NSArray                       *remotePhotos;

@property (nonatomic, copy) dispatch_block_t    imagePickedBlock;
@property (nonatomic, strong) void(^btnClickBlock)();
/// 
-(void)showImages:(NSArray *)images pickEnabled:(BOOL)pickEnabled;

-(CGSize)sizeWithImageCount:(NSInteger)count;

-(NSInteger)photoCount;

-(NSArray *)pickedPhotos ;
-(NSArray *)allPhotos ;
-(NSArray *)remotePhotos ;

-(JPPickerPhotoButton *)exitEmptyButton;


@end
