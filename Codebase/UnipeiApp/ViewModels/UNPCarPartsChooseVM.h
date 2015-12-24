//
//  UNPCarPartsChooseVM.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNPItemsChooseViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "InquiryApi_FindGcategory.h"
#import "InquiryApi_FindGcategoryChild.h"
#import "InquiryApi_FindGcategoryGrandchild.h"
#import <Mantle/Mantle.h>

static NSString *NOTIFY_String_carPartsSelected = @"carPartsSelected";

@interface UNPCarPartsChooseVM : NSObject <NSCopying>

/// 大类
@property (nonatomic, strong) UNPItemsChooseViewModel   *rootVM;
/// 子类
@property (nonatomic, strong) UNPItemsChooseViewModel   *subVM;
/// 配件
@property (nonatomic, strong) UNPItemsChooseViewModel   *partsVM;
/// 添加的配件
@property (nonatomic, strong, readonly) NSMutableArray        *selectedParts;

#pragma mark- 分组属性
@property (nonatomic, strong, readonly) NSArray                    *sectionTitles;
@property (nonatomic, strong, readonly) NSMutableDictionary        *allRootsDictionary;
@property (nonatomic, strong, readonly) NSMutableDictionary        *allSubsDictionary;
@property (nonatomic, strong, readonly) NSMutableDictionary        *allPartsDictionary;

/// 根据当前选择新增部件
-(void)addNewPart;

/// 使用传入字典，批量添加部件
-(void)addPartsWithData:(id)categorieList;

/// 部件Json字典数组
-(NSArray *)partJsonObjects;

/// 获取部件
-(void)getParts:(void(^)(InquiryApi_FindGcategoryGrandchild_Result *result))completion queue:(NSMutableArray *)queue;
/// 获取子类
-(void)getSubs:(void(^)(InquiryApi_FindGcategoryChild_Result *result))completion queue:(NSMutableArray *)queue;
/// 获取大类
-(void)getRoots:(void(^)(InquiryApi_FindGcategory_Result *result))completion queue:(NSMutableArray *)queue;

@end




/// 询价部件
@interface UNPInquiryPart : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *maincategory;
@property (nonatomic, copy) NSString *subcategory;
@property (nonatomic, copy) NSString *leafcategory;
@property (nonatomic, copy) NSNumber *partID;
@property (nonatomic, copy) NSNumber *number;
@property (nonatomic, copy) NSString *standcode;

-(id)jsonObject;

-(void)changeNumberBy:(NSInteger)number;

@end
