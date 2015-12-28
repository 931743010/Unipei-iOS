//
//  SupplementInfoImage.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/28.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "SupplementInfoImage.h"
#import "JPAddPhotoView.h"
@interface SupplementInfoImage()
@property (weak, nonatomic) IBOutlet JPAddPhotoView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SupplementInfoImage
-(void)configWithStr:(NSString *)str{
    self.nameLabel.text = str;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
