//
//  JPAddPhotoView.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/8.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPAddPhotoView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIImagePickerController+Helper.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "JPUtils.h"
#import "DymNavigationController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "ELCImagePickerController+Helper.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "JPPickerPhotoButton.h"


@interface JPAddPhotoView ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, MWPhotoBrowserDelegate> {
    
    NSMutableArray      *_buttons;  //保存当前所有按钮，提供界面设计时使用

    UIImage             *_defaultImage;
    
    NSMutableArray       *_showingPhotos;
    
    MWPhotoBrowser      *_browserPhotoVC;
}



@end



@implementation JPAddPhotoView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

//总条数
-(NSInteger)photoCount
{
    return [_buttons count];
}

//local buttons
-(NSArray *)pickedPhotos {
    NSMutableArray *photos = [NSMutableArray array];

    [_buttons enumerateObjectsUsingBlock:^(JPPickerPhotoButton *btn, NSUInteger idx, BOOL *stop) {
        if (btn.status!=kJPPickerEmpty && btn.status==kJPPickerLocal) {
            [photos addObject:[btn imageForState:UIControlStateNormal]];
        }
    }];

    return photos;
}

-(NSArray *)allPhotos {
    NSMutableArray *photos = [NSMutableArray array];
    [_buttons enumerateObjectsUsingBlock:^(JPPickerPhotoButton *btn, NSUInteger idx, BOOL *stop) {
     if (btn.status != kJPPickerEmpty) {
          [photos addObject:[btn imageForState:UIControlStateNormal]];
      }
    }];

    return photos;
}

-(NSArray *)remotePhotos {
    
    NSMutableArray *remotePhotos = [NSMutableArray array];
    
    [_buttons enumerateObjectsUsingBlock:^(JPPickerPhotoButton *btn, NSUInteger idx, BOOL *stop) {
        if (btn.status==kJPPickerRemote && btn.remoteInfo) {
            [remotePhotos addObject:btn.remoteInfo];
        }
    }];
    
    return remotePhotos;
}



-(void)doInit {
    _maxPhotoCount = 1;
    _numOfImagesPerRow = 3;
    _buttonGap = 8;
    _defaultImage = [UIImage imageNamed:@"btn_add_photo"];

    if (_buttonSize <= 0) {
//        _buttonSize = ([UIScreen mainScreen].bounds.size.width - _buttonGap * 6) / 5.0;
        _buttonSize = 56; //计算出来的值未使用
    }
    
    _buttons = [NSMutableArray array];
    _showingPhotos = [NSMutableArray array];
    
    [self installButtonWithImage:nil pickEnabled:YES];
}


-(void)reset {
    [_buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [_buttons removeAllObjects];

    [self installButtonWithImage:nil pickEnabled:YES];
}


-(NSArray *)buttonImages {
    NSMutableArray *buttonImages = [NSMutableArray array];
    [_buttons enumerateObjectsUsingBlock:^(JPPickerPhotoButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.status == kJPPickerLocal) {
            UIImage *image = obj.localImage;
            if (image) {
                [buttonImages addObject:image];
            }
        } else if (obj.status == kJPPickerRemote) {
            id image = obj.remoteInfo ? : obj.remotePath;
            if (image) {
                [buttonImages addObject:image];
            }
        }
//        else {
//            [buttonImages addObject:[NSNull null]];
//        }
    }];
    
    return buttonImages;
}
/// image can be a UIImage or an image url string
-(void)installButtonWithImage:(id)image pickEnabled:(BOOL)pickEnabled {

    JPPickerPhotoButton *button = [JPPickerPhotoButton new];
    button.contentMode = UIViewContentModeScaleAspectFill;

    
    if ([image isKindOfClass:[UIImage class]]) {
        [button setLocalImage:image];
    } else if ([image isKindOfClass:[NSString class]]) {
        
        [button setRemotePath:(NSString *)image];
        
    }  else if ([image isKindOfClass:[NSDictionary class]]) {
        
        NSString *relativePath = [image objectForKey:@"picpath"];
        NSString *fullPath = [JPUtils fullMediaPath:relativePath];
        
        [button setRemotePath:fullPath];
        button.remoteInfo = image;
        
    } else {
        [button setImage:_defaultImage forState:UIControlStateNormal];
        _plusBtn = button;
    }
    
    [self addSubview:button];
    
//    if(!image){
//       NSLog(@"==增加一个空按钮，%@",button);
//    }else{
//       NSLog(@"==添加一个按钮,%@",button);
//    }
    
    UIButton *lastButton = _buttons.lastObject;
    UIButton *firstButton = _buttons.firstObject;
    
    BOOL needNewLine = (_buttons.count % _numOfImagesPerRow == 0);

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(_buttonSize));
        make.height.equalTo(@(_buttonSize));
        
        if (firstButton == nil) {
            make.top.equalTo(self.mas_top);
            make.leading.equalTo(self.mas_leading);
        } else if (needNewLine) {
            make.top.equalTo(lastButton.mas_bottom).offset(_buttonGap);
            make.leading.equalTo(firstButton.mas_leading);
        } else {
            make.top.equalTo(lastButton.mas_top);
            make.leading.equalTo(lastButton.mas_trailing).offset(_buttonGap);
        }
    }];
    
    @weakify(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (pickEnabled && button.status==kJPPickerEmpty) {
             [self pickPhoto:x];
        }else{
//             [self browsePhoto:x];
            
            [self browsePhoto:x withPickEnabled:pickEnabled];

        }
        if (_btnClickBlock) {
            _btnClickBlock();
        }
    }];
    
    if (button.status!=kJPPickerEmpty) {
        [_buttons addObject:button];
    }
  
   
}

-(CGSize)intrinsicContentSize {
    return [self sizeWithImageCount:_buttons.count];
}

-(CGSize)sizeWithImageCount:(NSInteger)count {
    NSInteger rowCount = count / _numOfImagesPerRow;
    if (count % _numOfImagesPerRow != 0) {
        rowCount++;
    }
    
    if (rowCount <= 0) {
        rowCount = 1;
    }
    
    CGFloat width = _buttonSize * _numOfImagesPerRow + _buttonGap * (_numOfImagesPerRow - 1);
    CGFloat height = _buttonSize * rowCount + _buttonGap * (rowCount - 1);
    
    return CGSizeMake(width, height);
}

-(void)pickPhoto:(id)sender {
    [ELCImagePickerController pickImageWithDelegate:self presentingVC:_presentingVC withMaxPhotoCount:self.maxPhotoCount  currentCount:[[self allPhotos] count] ];
}

-(void)deleteButtonPressed:(id)sender {
    NSInteger currentIndex = _browserPhotoVC.currentIndex;
    
    //从界面删除选中按钮
    JPPickerPhotoButton *delBtn =  _buttons[currentIndex];
    [delBtn removeFromSuperview];
    [_buttons removeObjectAtIndex:currentIndex]; //内存中移除数据
    
    //从界面移除plus按钮
    NSArray *buttonImages = [self buttonImages];
    if (buttonImages.count>0) {
        [self showImages:buttonImages pickEnabled:YES];//更新
        [_browserPhotoVC reloadData];
    }else{  //删光等于0
        //返回
//        [self updateImages:nil pickEnabled:YES];
        [self showImages:buttonImages pickEnabled:YES];//更新
        //第一次
//         [self installButtonWithImage:nil pickEnabled:YES];

        [_browserPhotoVC doneButtonPressed:nil];
    }

}

-(void)browsePhoto:(id)sender withPickEnabled:(BOOL) pickEnabled {

    NSUInteger index = [_buttons indexOfObject:sender];
    if (index != NSNotFound) {
        //          NSLog(@"===browsePhoto,_showingPhotos.count=%d",_showingPhotos.count);
        //    if (index != NSNotFound && _buttons.count == _showingPhotos.count) {
        _browserPhotoVC = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        _browserPhotoVC.displayActionButton = NO;
        _browserPhotoVC.zoomPhotosToFill = YES;
        _browserPhotoVC.enableGrid = NO;
        _browserPhotoVC.autoPlayOnAppear = NO;
        //        _browserPhotoVC.pickEnabled = pickEnabled;
        if(pickEnabled){
            _browserPhotoVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"删除", nil) style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
            
        }
        
        [_browserPhotoVC setCurrentPhotoIndex:index];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:_browserPhotoVC];
        [[JPUtils topMostVC] presentViewController:nc animated:YES completion:nil];
    }
}

-(void)installPickButtonIfNeeded {
//    NSLog(@"==%s,_buttons.count=%d",__FUNCTION__,_buttons.count);
    if (_buttons.count < _maxPhotoCount) {
//        if (![self exitEmptyButton]) {
            [self installButtonWithImage:nil pickEnabled:YES];
//        }
    }
}
//


-(JPPickerPhotoButton *)exitEmptyButton
{
    for (JPPickerPhotoButton *btn in _buttons) {
        if (btn.status == kJPPickerEmpty) {
            return btn;
        }
    }
    return nil;
}

//更新页面和按钮数据源
-(void)showImages:(NSArray *)images pickEnabled:(BOOL)pickEnabled {
    
//    if (images.count <= 0) {
//        return;
//    }

    if (_plusBtn) {
//        NSLog(@"%s,removeFromSuperview",__FUNCTION__);
        [_plusBtn removeFromSuperview];
    }
    
    [_buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [_buttons removeAllObjects];

    

    
    [_showingPhotos removeAllObjects]; //清除旧照片数据源
    for (id image in images) {
        [self installButtonWithImage:image pickEnabled:pickEnabled];  //界面添加新按钮
        
        if ([image isKindOfClass:[UIImage class]]) {
            MWPhoto *photo = [MWPhoto photoWithImage:image];
            [_showingPhotos addObject:photo];
        } else if ([image isKindOfClass:[NSString class]]) { // image URL
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:image]];
            [_showingPhotos addObject:photo];
        } else if ([image isKindOfClass:[NSDictionary class]]) {
            NSString *relativePath = [image objectForKey:@"picpath"];
            NSString *fullPath = [JPUtils fullMediaPath:relativePath];
            
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:fullPath]];
            [_showingPhotos addObject:photo];
        }
    }
    
    if (pickEnabled) {
        [self installPickButtonIfNeeded];
    }

    if (_imagePickedBlock) {
        _imagePickedBlock();
    }
}


//更新页面和按钮数据源
-(void)updateImages:(NSArray *)images pickEnabled:(BOOL)pickEnabled {

//    JPPickerPhotoButton *plus = [self exitEmptyButton];
//    if (plus) {
//       [plus removeFromSuperview];
//    }
    
//    NSLog(@"%s,removeFromSuperview,%@",__FUNCTION__,_plusBtn);
    [_plusBtn removeFromSuperview];


    if([images count]==0){
        [_buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [_buttons removeAllObjects];
        [_showingPhotos removeAllObjects];
    }

    if (images) {
        for (id image in images) {
            [self installButtonWithImage:image pickEnabled:pickEnabled];
            if ([image isKindOfClass:[UIImage class]]) {
                MWPhoto *photo = [MWPhoto photoWithImage:image];
                [_showingPhotos addObject:photo];
            } else if ([image isKindOfClass:[NSString class]]) { // image URL
                MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:image]];
                [_showingPhotos addObject:photo];
            }
        }
    }
    
    if (pickEnabled && ([images count]!=0)) {
        [self installPickButtonIfNeeded];
    }



}


#pragma mark - photo browser delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _showingPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _showingPhotos.count) {
        return _showingPhotos[index];
    }
    return nil;
}


#pragma mark --  ELCImagePickerControllerDelegate delegate --

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    BOOL firstChoose = (_buttons.count==0)?YES:NO;
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];

                if (firstChoose) {  //第一次只添加
                    [self installButtonWithImage:image pickEnabled:YES];
                    
                    //创建浏览对象
                    if ([image isKindOfClass:[UIImage class]]) {
                        MWPhoto *photo = [MWPhoto photoWithImage:image];
                        [_showingPhotos addObject:photo];
                        
                    } else if ([image isKindOfClass:[NSString class]]) { // image URL
                        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:(NSString *)image]];
                        [_showingPhotos addObject:photo];
                    }
                    
                }
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo)  {
            NSLog(@"Uknown asset type");
        }
    }
    
    if (_imagePickedBlock) {
        _imagePickedBlock();
    }
    
    
    if (!firstChoose) {
        [self updateImages:images pickEnabled:YES];//更新数据源和页面
    }else{
        [self installPickButtonIfNeeded];
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *savedImage = [UIImagePickerController savePickingMediaWithInfo:info];
    
    BOOL firstChoose = (_buttons.count==0)?YES:NO;
    
    if (firstChoose) {  //第一次只添加
        [self installButtonWithImage:savedImage pickEnabled:YES];
        //创建浏览对象
        MWPhoto *photo = [MWPhoto photoWithImage:savedImage];
        [_showingPhotos addObject:photo];
        [self installPickButtonIfNeeded];
    }else {
//        [self installButtonWithImage:savedImage pickEnabled:YES];
        NSArray *imageArray =[[NSArray alloc]initWithObjects:savedImage, nil ] ;
        [self updateImages:imageArray pickEnabled:YES];//更新数据源和页面
    }
    
    if (_imagePickedBlock) {
        _imagePickedBlock();
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
