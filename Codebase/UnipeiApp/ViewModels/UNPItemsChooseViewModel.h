//
//  UNPItemsChooseViewModel.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIkit.h>

/// 用于item列表选择的view model类
@interface UNPItemsChooseViewModel : NSObject <NSCopying>

/// 记录此View Model发起请求的apiQueue，一般为相应view controller的apiQueue
@property (nonatomic, weak) NSMutableArray              *apiQueue;

/// 页面标题
@property (nonatomic, copy) NSString                    *title;

/// 是否允许多选
@property (nonatomic, assign) BOOL                      allowMultipleSelection;

/// 父Item
@property (nonatomic, strong) id                        parentItem;

/// items数据源
@property (nonatomic, copy)   NSArray                   *items;


/// 清除items, selectedItems;
-(void)reset;

/// 清除items但保留selectedItems
-(void)resetItemsKeepsSelected;

-(void)resetItemsAndSelectedItems;

/// 选中的item (单选)
-(id)selectedItem;

/// 选中的items (多选)
-(NSArray *)selectedItems;

/// 选中的index (单选)
-(NSNumber *)selectedIndex;

/// 选中的indexes (多选)
-(NSArray *)selectedIndexes;

/// 选择item
-(void)selectItem:(id)item;

/// 选第一个
-(void)selectFirstItem;

/// 不选item
-(void)unselectItem:(id)item;

/// 选择index
-(void)selectIndex:(NSUInteger)index;

/// 不选index
-(void)unselectIndex:(NSUInteger)index;

/// 全选
-(void)selectAll;

/// 全不选
-(void)unselectAll;

/// 子类重现，实现item相等的判断逻辑
-(BOOL)item:(id)item isEqualTo:(id)anotherItem;

@end
