//
//  UNPCarModelChooseVM.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNPItemsChooseViewModel.h"

#import "ModelPictureApi_FindMakeList.h"
#import "ModelPictureApi_FindSeriesList.h"
#import "ModelPictureApi_FindYearList.h"
#import "ModelPictureApi_FindModelList.h"
#import "ModelPictureApi_FindModelPictureList.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JPInquiry.h"

/// 这个枚举仅用于fullName显示
typedef NS_ENUM(NSInteger, EJPCarModelNameLevel) {
    kJPCarModelNameLevelBrand = 1   // 品牌
    , kJPCarModelNameLevelSeries
    , kJPCarModelNameLevelYear
    , kJPCarModelNameLevelModel
};

static NSString *NOTIFY_String_carModelSelected = @"carModelSelected";

@class UNPBrandChooseVM;
@class UNPSeriesChooseVM;
@class UNPYearChooseVM;
@class UNPModelChooseVM;

@interface UNPCarModelChooseVM : NSObject <NSCopying>

@property (nonatomic, strong) UNPBrandChooseVM   *brandVM;
@property (nonatomic, strong) UNPSeriesChooseVM   *seriesVM;
@property (nonatomic, strong) UNPYearChooseVM   *yearVM;
@property (nonatomic, strong) UNPModelChooseVM   *modelVM;

@property (nonatomic, strong, readonly) NSMutableDictionary        *allBrands;
@property (nonatomic, strong, readonly) NSArray                    *sectionTitles;

-(NSString *)fullName;

-(NSString *)fullNameWithLevel:(EJPCarModelNameLevel)level;

-(void)setSelectionWithInquiry:(JPInquiry *)inquiry;

-(void)syncData;

-(void)getAllMakes:(void(^)(ModelPictureApi_FindMakeList_Result *result))completion queue:(NSMutableArray *)queue;

-(void)getSeries:(void(^)(ModelPictureApi_FindSeriesList_Result *result))completion queue:(NSMutableArray *)queue;

-(void)getYears:(void(^)(ModelPictureApi_FindYearList_Result *result))completion queue:(NSMutableArray *)queue;

-(void)getModels:(void(^)(ModelPictureApi_FindModelList_Result *result))completion queue:(NSMutableArray *)queue;

@end

///
@interface UNPBrandChooseVM : UNPItemsChooseViewModel
@end

@interface UNPSeriesChooseVM : UNPItemsChooseViewModel
@end

@interface UNPYearChooseVM : UNPItemsChooseViewModel
@end

@interface UNPModelChooseVM : UNPItemsChooseViewModel
@end
