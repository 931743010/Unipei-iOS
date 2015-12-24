//
//  UNPPersonalPushVC.h
//  DymIOSApp
//
//  Created by xujun on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"
#import "JPLimitedTextField.h"

typedef NS_ENUM(NSInteger, EJPTextModifyType) {
    kJPTextModifyTypeOrganizationname = 0
    , kJPTextModifyTypeEmailadress
    , kJPTextModifyTypeQQnumber
    , kJPTextModifyTypePhone
    , kJPTextModifyTypeFax
};

typedef void(^UNPTextModifiedBlock)(NSString *modifiedText, EJPTextModifyType modifyType);

@interface UNPTextModifyVC : DymBaseVC
@property (weak, nonatomic) IBOutlet UILabel *lblAnnotation;
@property (weak, nonatomic) IBOutlet JPLimitedTextField *textField;
@property (nonatomic,assign) EJPTextModifyType      modifyType;

@property (nonatomic, copy) UNPTextModifiedBlock  textModifiedBlock;

@end
