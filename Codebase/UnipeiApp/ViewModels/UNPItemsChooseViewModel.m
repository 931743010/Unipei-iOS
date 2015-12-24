//
//  UNPItemsChooseViewModel.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPItemsChooseViewModel.h"

@interface UNPItemsChooseViewModel ()
@property (nonatomic, strong)   NSMutableArray     *selectedItems;
@end


@implementation UNPItemsChooseViewModel

-(id)copyWithZone:(NSZone *)zone {
    UNPItemsChooseViewModel *copy = [[[self class] allocWithZone:zone] init];
    
    copy.items = [self.items copyWithZone:zone];
    copy.selectedItems = [self.selectedItems mutableCopyWithZone:zone];
    copy.title = [self.title copyWithZone:zone];
    
    copy.apiQueue = self.apiQueue;
    copy.allowMultipleSelection = self.allowMultipleSelection;
    copy.parentItem = self.parentItem;
    
    return copy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedItems = [NSMutableArray array];
    }
    return self;
}

-(void)resetItemsKeepsSelected {
    _items = nil;
}

-(void)resetItemsAndSelectedItems {
    _items = nil;
    [_selectedItems removeAllObjects];
}

-(void)setItems:(NSArray *)items {
    
    _items = [items copy];
    
    NSMutableArray *itemsToBeRemoved = [NSMutableArray array];
    
    for (id selectedItem in _selectedItems) {
        
        BOOL exists = NO;
        
        for (id item in items) {
            if ([self item:item isEqualTo:selectedItem]) {
                exists = YES;
                break;
            }
        }
        
        if (!exists) {
            [itemsToBeRemoved addObject:selectedItem];
        }
    }
    
    [_selectedItems removeObjectsInArray:itemsToBeRemoved];
}


#pragma mark - readonly
-(void)reset {
    [self setItems:nil];
}


-(id)selectedItem {
    return _selectedItems.firstObject;
}

-(NSArray *)selectedItems {
    return _selectedItems;
}

-(NSNumber *)selectedIndex {
    return [self selectedIndexes].firstObject;
}

-(NSArray *)selectedIndexes {
    NSMutableArray *indexes = [NSMutableArray array];
    for (id item in _selectedItems) {
        NSUInteger index = [_items indexOfObject:item];
        if (index != NSNotFound) {
            [indexes addObject:@(index)];
        }
    }
    
    return indexes;
}


#pragma mark - actions
-(void)selectFirstItem {
    [self selectItem:self.items.firstObject];
}

-(void)selectItem:(id)item {
    
    if (item == nil) {
        return;
    }
    
    BOOL hasSelected = NO;
    NSInteger replaceIndex = -1;
    for (id selectedItem in _selectedItems) {
        if ([self item:item isEqualTo:selectedItem]) {
            hasSelected = YES;
            replaceIndex = [_selectedItems indexOfObject:selectedItem];
        }
    }
    
    if (!hasSelected) {
        
        if (!_allowMultipleSelection) {
            [_selectedItems removeAllObjects];
        }
        
        [_selectedItems addObject:item];
    } else if (replaceIndex > 0) {
        [_selectedItems replaceObjectAtIndex:replaceIndex withObject:item];
    }
}

-(BOOL)item:(id)item isEqualTo:(id)anotherItem {
    return item == anotherItem;
}

-(void)unselectItem:(id)item {
    [_selectedItems removeObject:item];
}

-(void)selectIndex:(NSUInteger)index {
    id item = _items[index];
    
    [self selectItem:item];
}

-(void)unselectIndex:(NSUInteger)index {
    id item = _items[index];
    
    [self unselectItem:item];
}


/// 全选
-(void)selectAll {
    _selectedItems = [_items mutableCopy];
}

/// 全不选
-(void)unselectAll {
    [_selectedItems removeAllObjects];
}

@end
