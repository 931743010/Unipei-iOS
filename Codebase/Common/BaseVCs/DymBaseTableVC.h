//
//  DymBaseTableVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BasicBehavior.h"

/// Table view controller的基类
@interface DymBaseTableVC : UITableViewController

@end


/// 显示loading和empty状态的tableviewController基类
@interface DymBaseLoadingTableVC : DymBaseTableVC

/// 空态cell
@property (nonatomic, strong, readonly) UITableViewCell  *emptyCell;
/// loading cell
@property (nonatomic, strong, readonly) UITableViewCell  *loadingCell;
/// 是否正在加载数据源，加载和结束加载数据时修改
@property (nonatomic, assign) BOOL  dataSourceIsLoading;
/// 空态时的提示消息
@property (nonatomic, copy) NSString  *emptyMessage;

#pragma mark tableview datasource相关
/// Default YES, 是否在无数据时显示empty cell，子类可重写
-(BOOL)showEmptyCellIfNeeded;
/// Default YES, 是否在无数据时显示loading cell，子类可重写
-(BOOL)showLoadingCellIfNeeded;
/// 是否无数据显示，子类重写
-(BOOL)isDataSourceEmpty;
/// 空数据时，是否允许下拉
-(BOOL)allowBounceWhenDataSourceIsEmpty;

/// 数据源不为空且不在加载时，section的数量，子类重写
-(NSInteger)numberOfSectionsInTableView_IfDataOK:(UITableView *)tableView;
/// 数据源不为空且不在加载时，section中row的数量，子类重写
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection_IfDataOK:(NSInteger)section;
/// 数据源不为空且不在加载时，section header的高度，子类重写
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection_IfDataOK:(NSInteger)section;
/// 数据源不为空且不在加载时，row的高度，子类重写
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath_IfDataOK:(NSIndexPath *)indexPath;

@end
