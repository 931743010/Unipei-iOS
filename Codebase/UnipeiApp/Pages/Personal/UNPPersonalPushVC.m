//
//  UNPPersonalPushVC.m
//  DymIOSApp
//
//  Created by xujun on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPPersonalPushVC.h"

@interface UNPPersonalPushVC ()
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

@implementation UNPPersonalPushVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    self.navigationItem.rightBarButtonItem = confirm;
    self.navigationItem.hidesBackButton = YES;
    
}
-(void)confirm{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_textfield resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
