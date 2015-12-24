//
//  EditVinViewController.h
//  DymIOSApp
//
//  Created by MacBook on 11/12/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditVinViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *vinImageView;
@property (weak, nonatomic) IBOutlet UITextField *vinTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;



@property(nonatomic,copy) NSString *vinResultTxt;
@property(nonatomic,strong) UIImage *vinResultImage;

- (IBAction)confirmVin:(id)sender;

@end
