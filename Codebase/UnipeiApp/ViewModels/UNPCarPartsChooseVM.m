//
//  UNPCarPartsChooseVM.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPCarPartsChooseVM.h"
#import "DymRequest+Helper.h"
#import "JPAppStatus.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

//static const DDLogLevel ddLogLevel = DDLogLevelDebug;




//////////////////////////////////
@implementation UNPCarPartsChooseVM

- (id)copyWithZone:(NSZone *)zone {
    
    UNPCarPartsChooseVM *copy = [[[self class] allocWithZone:zone] init];
    copy.rootVM = [self.rootVM copyWithZone:zone];
    copy.subVM = [self.subVM copyWithZone:zone];
    copy.partsVM = [self.partsVM copyWithZone:zone];
    
    copy->_sectionTitles = [self.sectionTitles copyWithZone:zone];
    copy->_allRootsDictionary = [self.allRootsDictionary mutableCopyWithZone:zone];
    copy->_allSubsDictionary = [self.allSubsDictionary mutableCopyWithZone:zone];
    copy->_allPartsDictionary = [self.allPartsDictionary mutableCopyWithZone:zone];

    copy->_selectedParts = [self.selectedParts mutableCopyWithZone:zone];

    
    return copy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _rootVM = [UNPItemsChooseViewModel new];
        _rootVM.title = @"选择大类";
        
        _subVM = [UNPItemsChooseViewModel new];
        _subVM.title = @"选择子类";
        
        _partsVM = [UNPItemsChooseViewModel new];
        _partsVM.title = @"选择标准名称";
        
        
        _selectedParts = [NSMutableArray array];
        
        _sectionTitles = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
        _allRootsDictionary = [NSMutableDictionary dictionary];
        _allSubsDictionary = [NSMutableDictionary dictionary];
        _allPartsDictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(NSArray *)partJsonObjects {
    NSMutableArray *partJsonObjects = [NSMutableArray array];
    
    for (UNPInquiryPart *part in _selectedParts) {
        [partJsonObjects addObject:[part jsonObject]];
    }
    return partJsonObjects;
}

-(void)addNewPart {
    id root = _rootVM.selectedItem;
    id sub = _subVM.selectedItem;
    id part = _partsVM.selectedItem;
    
    if (root && sub && part) {
        id partID = [part objectForKey:@"id"];
        
        UNPInquiryPart *newPartObject = [UNPInquiryPart new];
        newPartObject.partID = partID;
        newPartObject.maincategory = [root objectForKey:@"name"];
        newPartObject.subcategory = [sub objectForKey:@"name"];
        newPartObject.leafcategory = [part objectForKey:@"name"];
        newPartObject.number = @1;
        newPartObject.standcode = [part objectForKey:@"code"];
        
        [self addPart:newPartObject];
    }
}

-(void)addPart:(UNPInquiryPart *)part {
    
    /// 检查是不是加了
    BOOL added = NO;
    for (UNPInquiryPart *partObject in _selectedParts) {
        if ([partObject.partID longLongValue] == [part.partID longLongValue]) {
            
            [partObject changeNumberBy:1];
            added = YES;
            
            break;
        }
    }
    
    /// 没有加就加上
    if (!added) {
        [_selectedParts addObject:part];
    }
}

-(void)addPartsWithData:(id)categorieList {
    if (categorieList == nil) {
        return;
    }
    
    for (id cateData in categorieList) {
        UNPInquiryPart *part = [UNPInquiryPart new];
        part.partID = cateData[@"id"];
        part.maincategory = cateData[@"maincategory"];
        part.subcategory = cateData[@"subcategory"];
        part.leafcategory = cateData[@"leafcategory"];
        part.number = cateData[@"number"];
        part.standcode = cateData[@"standcode"];
        
        [self addPart:part];
    }
}

#pragma mark - requests
-(void)getParts:(void(^)(InquiryApi_FindGcategoryGrandchild_Result *result))completion queue:(NSMutableArray *)queue {
    
    id parentID = [_subVM.selectedItem objectForKey:@"id"];
    [[self getPartsSignal:parentID queue:queue] subscribeNext:^(InquiryApi_FindGcategoryGrandchild_Result *result) {
        if ([result isKindOfClass:[InquiryApi_FindGcategoryGrandchild_Result class]]) {
            _partsVM.items = result.list;
            
            /// Group parts into sections
            NSMutableDictionary *allItemsDic = [NSMutableDictionary dictionaryWithCapacity:_sectionTitles.count];
            
            for (NSString *title in _sectionTitles) {
                [allItemsDic setObject:[NSMutableArray array] forKey:title];
            }
            
            for (id item in _partsVM.items) {
                if (item[@"pinY"]) {
                    NSMutableArray *arr = [allItemsDic objectForKey:item[@"pinY"]];
                    [arr addObject:item];
                }
            }
            
            [_allPartsDictionary removeAllObjects];
            for (NSString *key in _sectionTitles) {
                NSMutableArray *arr = [allItemsDic objectForKey:key];
                if (arr.count > 0) {
                    [_allPartsDictionary setObject:arr forKey:key];
                }
            }
        }
        
        if (completion) {
            completion(result);
        }
    }];
}

-(void)getSubs:(void(^)(InquiryApi_FindGcategoryChild_Result *result))completion queue:(NSMutableArray *)queue {
    
    id parentID = [_rootVM.selectedItem objectForKey:@"id"];
    [[self getSubsSignal:parentID queue:queue] subscribeNext:^(InquiryApi_FindGcategoryChild_Result *result) {
        if ([result isKindOfClass:[InquiryApi_FindGcategoryChild_Result class]]) {
            _subVM.items = result.list;
            
            /// Group subs into sections
            NSMutableDictionary *allItemsDic = [NSMutableDictionary dictionaryWithCapacity:_sectionTitles.count];
            
            for (NSString *title in _sectionTitles) {
                [allItemsDic setObject:[NSMutableArray array] forKey:title];
            }
            
            for (id item in _subVM.items) {
                if (item[@"pinY"]) {
                    NSMutableArray *arr = [allItemsDic objectForKey:item[@"pinY"]];
                    [arr addObject:item];
                }
            }
            
            [_allSubsDictionary removeAllObjects];
            for (NSString *key in _sectionTitles) {
                NSMutableArray *arr = [allItemsDic objectForKey:key];
                if (arr.count > 0) {
                    [_allSubsDictionary setObject:arr forKey:key];
                }
            }
        }
        
        if (completion) {
            completion(result);
        }
    }];
}

-(void)getRoots:(void(^)(InquiryApi_FindGcategory_Result *result))completion queue:(NSMutableArray *)queue {
    
    [[self getRootsSignal:queue] subscribeNext:^(InquiryApi_FindGcategory_Result *result) {
        if ([result isKindOfClass:[InquiryApi_FindGcategory_Result class]]) {
            _rootVM.items = result.list;
            
            /// Group roots into sections
            NSMutableDictionary *allItemsDic = [NSMutableDictionary dictionaryWithCapacity:_sectionTitles.count];
            
            for (NSString *title in _sectionTitles) {
                [allItemsDic setObject:[NSMutableArray array] forKey:title];
            }
            
            for (id item in _rootVM.items) {
                if (item[@"pinY"]) {
                    NSMutableArray *arr = [allItemsDic objectForKey:item[@"pinY"]];
                    [arr addObject:item];
                }
            }
            
            [_allRootsDictionary removeAllObjects];
            for (NSString *key in _sectionTitles) {
                NSMutableArray *arr = [allItemsDic objectForKey:key];
                if (arr.count > 0) {
                    [_allRootsDictionary setObject:arr forKey:key];
                }
            }
        }
        
        if (completion) {
            completion(result);
        }
    }];
}

#pragma mark - signals
-(RACSignal *)getPartsSignal:(NSNumber *)parentID queue:(NSMutableArray *)apiQueue {
    
    id params = @{@"parentID": parentID ? : @0};
    return [DymRequest commonApiSignalWithClass:[InquiryApi_FindGcategoryGrandchild class] queue:apiQueue params:params];
}

-(RACSignal *)getSubsSignal:(NSNumber *)parentID queue:(NSMutableArray *)apiQueue {
    
    id params = @{@"parentID": parentID ? : @0};
    return [DymRequest commonApiSignalWithClass:[InquiryApi_FindGcategoryChild class] queue:apiQueue params:params];
}

-(RACSignal *)getRootsSignal:(NSMutableArray *)apiQueue {
    
    return [DymRequest commonApiSignalWithClass:[InquiryApi_FindGcategory class] queue:apiQueue params:nil];
}

@end



/////////////////
@implementation UNPInquiryPart

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
     return @{
         @"maincategory": @"maincategory"
         , @"subcategory": @"subcategory"
         , @"leafcategory": @"leafcategory"
         , @"number": @"number"
         , @"standcode": @"standcode"
     };
}

-(id)jsonObject {
    return [MTLJSONAdapter JSONDictionaryFromModel:self error:nil];
}

-(void)changeNumberBy:(NSInteger)number {
    _number = @([_number longLongValue] + number);
}

@end
