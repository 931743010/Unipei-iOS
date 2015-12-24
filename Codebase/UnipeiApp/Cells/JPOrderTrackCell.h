//
//  JPOrderTrackCell.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/29.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EJPCellPosition) {
    kJPCellPositionFirst = 0
    , kJPCellPositionCenter
    , kJPCellPositionLast
    , kJPCellPositionAlone
};

@interface JPOrderTrackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;


-(void)setPos:(EJPCellPosition)pos;
@end
