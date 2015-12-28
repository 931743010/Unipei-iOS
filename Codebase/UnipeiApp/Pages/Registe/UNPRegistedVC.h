//
//  UNPRegistedVC.h
//  DymIOSApp
//
//  Created by xujun on 15/12/24.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"
typedef NS_ENUM(NSInteger, EJPRegistedPhotoType) {

    kJPRegistedPhotoTypeLisence = 1
    , kJPRegistedPhotoTypeStore
    , kJPRegistedPhotoTypeCard
    
};
typedef NS_ENUM(NSInteger, EJPRegistedRecomType) {

    kJPRegistedRecomTypeDealer = 1
    , kJPRegistedRecomTypeSalesman

};
typedef NS_ENUM(NSInteger, EJPRegistedTextFieldType) {

    kJPRegistedTextFieldTypeOrganName = 0
    , kJPRegistedTextFieldTypeName
    , kJPRegistedTextFieldTypePhone
    , kJPRegistedTextFieldTypeAdress
    , kJPRegistedTextFieldTypeRecommend
    , kJPRegistedTextFieldTypeRegistration
    
};

@interface UNPRegistedVC : DymBaseVC
@property (nonatomic, assign) EJPRegistedPhotoType registedPhototype;
@property (nonatomic, assign) EJPRegistedRecomType registedRecomType;
@property (nonatomic, assign) EJPRegistedTextFieldType textFieldType;
@end
