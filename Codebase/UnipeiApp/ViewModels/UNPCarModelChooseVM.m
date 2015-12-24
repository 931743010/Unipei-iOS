//
//  UNPCarModelChooseVM.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/21.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPCarModelChooseVM.h"
#import "DymRequest+Helper.h" 
#import "JPAppStatus.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static const DDLogLevel ddLogLevel = DDLogLevelDebug;

@implementation UNPCarModelChooseVM


- (id)copyWithZone:(NSZone *)zone {
    
    UNPCarModelChooseVM *copy = [[[self class] allocWithZone:zone] init];
    copy.brandVM = [self.brandVM copyWithZone:zone];
    copy.seriesVM = [self.seriesVM copyWithZone:zone];
    copy.yearVM = [self.yearVM copyWithZone:zone];
    copy.modelVM = [self.modelVM copyWithZone:zone];
    copy->_allBrands = [self.allBrands mutableCopyWithZone:zone];
    copy->_sectionTitles = [self.sectionTitles copyWithZone:zone];
    
    return copy;
}

-(NSString *)fullName {
    return [self fullNameWithLevel:kJPCarModelNameLevelModel];
}

-(NSString *)fullNameWithLevel:(EJPCarModelNameLevel)level {
    NSMutableArray *arr = [NSMutableArray array];
    JPCarMake *brand = _brandVM.selectedItem;
    
    if (brand) {
        [arr addObject:brand.mName];
        JPCarSeries *series = _seriesVM.selectedItem;
        
        if (series && level > kJPCarModelNameLevelBrand) {
            [arr addObject:@" "];
            [arr addObject:series.name];
            id year = _yearVM.selectedItem;
            
            if (year && level > kJPCarModelNameLevelSeries) {
                [arr addObject:@" "];
                if ([year[@"year"] integerValue] > 0) {
                    [arr addObject:[NSString stringWithFormat:@"%@款", year[@"year"]]];
                } else {
                    [arr addObject:@"不确定年款"];
                }
                
                JPCarModel *model = _modelVM.selectedItem;
                
                if (model && level > kJPCarModelNameLevelYear) {
                    [arr addObject:@" "];
                    [arr addObject:model.name];
                    
                    // 如果是超长字符串就换行
                    if ([arr componentsJoinedByString:@""].length > 18) {
                        [arr removeLastObject];
                        [arr addObject:[NSString stringWithFormat:@"\n%@", model.name]];
                    }
                }
            }
        }
    }
    
    return [arr componentsJoinedByString:@""];
}


-(void)setSelectionWithInquiry:(JPInquiry *)inquiry {
    
    if ([inquiry.make longLongValue] > 0) {
        JPCarMake *brand = [JPCarMake new];
        brand.makeid = inquiry.make;
        brand.name = inquiry.makeName;
        brand.mName = inquiry.makeName;
        [_brandVM selectItem:brand];
        
        if (inquiry.carName.length) {
            JPCarSeries *series = [JPCarSeries new];
            series.seriesid = inquiry.car;
            series.name = inquiry.carName;
            series.makeid = brand.makeid;
            [_seriesVM selectItem:series];
            
            if ([inquiry.car longLongValue] > 0 && inquiry.year) {
                if ([inquiry.year longLongValue] > 0) {
                    NSDictionary *yearDic = @{@"year": inquiry.year, @"id": series.seriesid};
                    [_yearVM selectItem:yearDic];
                } else {
                    [_yearVM selectItem:[self defaultYearWithSeriesID:series.seriesid]];
                }
                
                
                if (inquiry.modelName.length) {
                    JPCarModel *model = [JPCarModel new];
                    model.modelid = inquiry.model;
                    model.year = @([inquiry.year integerValue]);
                    model.seriesid = series.seriesid;
                    model.name = inquiry.modelName;
                    
                    [_modelVM selectItem:model];
                }
            }
        }
    }
}

-(void)syncData {
    if ([((JPCarMake *)_seriesVM.parentItem).makeid longLongValue] != [((JPCarMake *)_brandVM.selectedItem).makeid longLongValue]) {
        
        [_seriesVM reset];
        [_yearVM reset];
        [_modelVM reset];
        
    } else if ([((JPCarSeries *)_yearVM.parentItem).seriesid longLongValue] != [((JPCarSeries *)_seriesVM.selectedItem).seriesid longLongValue]) {
        
        [_yearVM reset];
        [_modelVM reset];
        
    }  else if ([((NSNumber *)_modelVM.parentItem) longLongValue] != [((NSNumber *)_yearVM.selectedItem) longLongValue]) {
        [_modelVM reset];
    }
}

#pragma mark -
- (instancetype)init
{
    self = [super init];
    if (self) {
        _brandVM = [UNPBrandChooseVM new];
        _brandVM.title = @"选择品牌";
        
        _seriesVM = [UNPSeriesChooseVM new];
        _seriesVM.title = @"选择车系";
        
        _yearVM = [UNPYearChooseVM new];
        _yearVM.title = @"选择年款";
        
        _modelVM = [UNPModelChooseVM new];
        _modelVM.title = @"选择车型";
        
        _allBrands = [NSMutableDictionary dictionary];
        
        _sectionTitles = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    }
    
    return self;
}

-(void)getAllMakes:(void(^)(ModelPictureApi_FindMakeList_Result *result))completion queue:(NSMutableArray *)queue {
    
    [[self getAllMakeSignal:queue] subscribeNext:^(ModelPictureApi_FindMakeList_Result *result) {
        
        if ([result isKindOfClass:[ModelPictureApi_FindMakeList_Result class]]) {
            _brandVM.items = result.brandList;
            
            /// Group brands into sections
            NSMutableDictionary *allBrandsDic = [NSMutableDictionary dictionaryWithCapacity:_sectionTitles.count];
            
            for (NSString *title in _sectionTitles) {
                [allBrandsDic setObject:[NSMutableArray array] forKey:title];
            }
            
            for (JPCarMake *brand in _brandVM.items) {
                NSMutableArray *arr = [allBrandsDic objectForKey:brand.firstChar];
                [arr addObject:brand];
            }
            
            [_allBrands removeAllObjects];
            for (NSString *key in _sectionTitles) {
                NSMutableArray *arr = [allBrandsDic objectForKey:key];
                if (arr.count > 0) {
                    [_allBrands setObject:arr forKey:key];
                }
            }
        }
        
        if (completion) {
            completion(result);
        }
    }];
}

-(void)getSeries:(void(^)(ModelPictureApi_FindSeriesList_Result *result))completion queue:(NSMutableArray *)queue {
    
    JPCarMake *brand = _seriesVM.parentItem;
    [[self getSeriesSignal:brand.makeid queue:queue] subscribeNext:^(ModelPictureApi_FindSeriesList_Result *result) {

        if ([result isKindOfClass:[ModelPictureApi_FindSeriesList_Result class]]) {
            
            NSMutableArray *series = [result.seriesList mutableCopy];
            if (series == nil) {
                series = [NSMutableArray array];
            }
            
            JPCarSeries *defaultItem = [JPCarSeries new];
            defaultItem.makeid = brand.makeid;
            defaultItem.seriesid = @0;
            defaultItem.name = @"不确定车系";
            [series insertObject:defaultItem atIndex:0];
            
            _seriesVM.items = series;
        }
        
        if (completion) {
            completion(result);
        }
        
    }];
}


-(void)getYears:(void(^)(ModelPictureApi_FindYearList_Result *result))completion queue:(NSMutableArray *)queue {
    
    JPCarSeries *series = _yearVM.parentItem;
    [[self getYearsSignal:series.seriesid queue:queue] subscribeNext:^(ModelPictureApi_FindYearList_Result *result) {
        
        if ([result isKindOfClass:[ModelPictureApi_FindYearList_Result class]]) {
            NSArray *years = result.yearList;
            NSMutableArray *yearsWithIDs = [NSMutableArray array];
            
            [yearsWithIDs addObject:[self defaultYearWithSeriesID:series.seriesid]];
            
            for (NSNumber *year in years) {
                [yearsWithIDs addObject:@{@"year": year, @"id": series.seriesid}];
            }
            
            _yearVM.items = yearsWithIDs;
//            if (_yearVM.selectedItem == nil) {
//                [_yearVM selectFirstItem];
//            }
        }
        
        if (completion) {
            completion(result);
        }
        
    }];
}

-(void)getModels:(void(^)(ModelPictureApi_FindModelList_Result *result))completion queue:(NSMutableArray *)queue {
    
    JPCarSeries *series = _yearVM.parentItem;
    id year = (_modelVM.parentItem)[@"year"];
    
    [[self getModelsSignal:series.seriesid year:year queue:queue] subscribeNext:^(ModelPictureApi_FindModelList_Result *result) {
        if ([result isKindOfClass:[ModelPictureApi_FindModelList_Result class]]) {
            _modelVM.items = result.modelList;
            
            NSMutableArray *models = [result.modelList mutableCopy];
            if (models == nil) {
                models = [NSMutableArray array];
            }
            
            JPCarModel *defaultItem = [JPCarModel new];
            defaultItem.modelid = @0;
            defaultItem.name = @"不确定车型";
            defaultItem.seriesid = series.seriesid;
            defaultItem.makeid = series.makeid;
            defaultItem.year = year;
            [models insertObject:defaultItem atIndex:0];
            
            _modelVM.items = models;
        }
        
        if (completion) {
            completion(result);
        }
    }];
    
}

#pragma mark - default year item
-(id)defaultYearWithSeriesID:(id)seriesID {
    return @{@"year": @0, @"id": seriesID};
}

#pragma mark - signals
-(RACSignal *)getModelPicturesSignal:(NSNumber *)modelID queue:(NSMutableArray *)apiQueue {
    
    id params = @{@"modelID": modelID ? : @0};
    return [DymRequest commonApiSignalWithClass:[ModelPictureApi_FindModelPictureList class] queue:apiQueue params:params];
    
}


-(RACSignal *)getModelsSignal:(NSNumber *)seriesId year:(NSNumber *)year queue:(NSMutableArray *)apiQueue {
    
    id params = @{@"seriesID": seriesId ? : @0, @"year": year ? : @0};
    return [DymRequest commonApiSignalWithClass:[ModelPictureApi_FindModelList class] queue:apiQueue params:params];
}


-(RACSignal *)getYearsSignal:(NSNumber *)seriesId queue:(NSMutableArray *)apiQueue {
    
    id params = @{@"seriesID": seriesId ? : @0};
    return [DymRequest commonApiSignalWithClass:[ModelPictureApi_FindYearList class] queue:apiQueue params:params];
}


-(RACSignal *)getSeriesSignal:(NSNumber *)makeId queue:(NSMutableArray *)apiQueue {
    
    id params = @{@"makeId": makeId ? : @0};
    return [DymRequest commonApiSignalWithClass:[ModelPictureApi_FindSeriesList class] queue:apiQueue params:params];
}


-(RACSignal *)getAllMakeSignal:(NSMutableArray *)apiQueue {
    
    return [DymRequest commonApiSignalWithClass:[ModelPictureApi_FindMakeList class] queue:apiQueue params:nil];
}


@end


@implementation UNPBrandChooseVM
-(BOOL)item:(id)item isEqualTo:(id)anotherItem {
    JPCarMake *brand1 = item;
    JPCarMake *brand2 = anotherItem;
    
    DDLogDebug(@"make id: %@ == %@ ?", brand1.makeid, brand2.makeid);
    
    return [brand1.makeid longLongValue] == [brand2.makeid longLongValue];
}
@end

@implementation UNPSeriesChooseVM
-(BOOL)item:(id)item isEqualTo:(id)anotherItem {
    JPCarSeries *series1 = item;
    JPCarSeries *series2 = anotherItem;
    return [series1.seriesid longLongValue] == [series2.seriesid longLongValue];
}
@end

@implementation UNPYearChooseVM
-(BOOL)item:(id)item isEqualTo:(id)anotherItem {
    return [item[@"year"] longLongValue] == [anotherItem[@"year"] longLongValue];
}
@end

@implementation UNPModelChooseVM
-(BOOL)item:(id)item isEqualTo:(id)anotherItem {
    JPCarModel *model1 = item;
    JPCarModel *model2 = anotherItem;
    return [model1.modelid longLongValue] == [model2.modelid longLongValue];
}
@end
