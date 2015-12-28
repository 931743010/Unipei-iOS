//
//  UNPRegistedUpLoadPicCell.h
//  DymIOSApp
//
//  Created by xujun on 15/12/24.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPAddPhotoView.h"

@interface UNPRegistedUpLoadPicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnLicense;
@property (weak, nonatomic) IBOutlet UIButton *btnStore;
@property (weak, nonatomic) IBOutlet UIButton *btnCard;
@property (weak, nonatomic) IBOutlet JPAddPhotoView *addPhotoView;

@end
