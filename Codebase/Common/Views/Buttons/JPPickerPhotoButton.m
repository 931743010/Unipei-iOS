//
//  JPPickerPhotoButton.m
//  DymIOSApp
//
//  Created by QinJun on 11/5/15.
//  Copyright © 2015 Jiaparts. All rights reserved.
//

#import "JPPickerPhotoButton.h"
#import <SDWebImage/UIButton+WebCache.h>


@implementation JPPickerPhotoButton


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

-(void) doInit
{
     _defaultImage = [UIImage imageNamed:@"btn_add_photo"];
}


-(void)setRemotePath:(NSString *) remotePath{
    if (remotePath) {
        NSURL *imageURL = [NSURL URLWithString:(NSString *)remotePath];
        [self sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empty_photo"]];
        _remotePath = remotePath;
        _status = kJPPickerRemote;
    }else {
        [self setImage:_defaultImage forState:UIControlStateNormal];
        _status = kJPPickerEmpty;
    }
}

-(void)setLocalImage:(UIImage *) localImage{
    if (localImage) {
        [self setImage:localImage forState:UIControlStateNormal];
        _localImage = localImage;
        _status = kJPPickerLocal;
    }else{
        [self setImage:_defaultImage forState:UIControlStateNormal];
         _status = kJPPickerEmpty;
    }

}

@end
