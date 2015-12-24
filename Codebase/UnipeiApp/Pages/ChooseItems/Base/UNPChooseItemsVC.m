//
//  UNPChooseItemsVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/19.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseItemsVC.h"

@interface UNPChooseItemsVC ()

@end

@implementation UNPChooseItemsVC


-(void)loadView {
    [super loadView];
    
    _rootView = [[NSBundle mainBundle] loadNibNamed:@"UNPChooseItemsView" owner:self options:nil].firstObject;
    self.view = _rootView;;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lazyBlock = [JPLazyBlock new];
    
    _rootView.tableView.rowHeight = UITableViewAutomaticDimension;
    _rootView.tableView.estimatedRowHeight = 48;
    _rootView.tableView.delegate = self;
    _rootView.tableView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"UNPChooseItemCell" bundle:nil];
    [_rootView.tableView registerNib:cellNib forCellReuseIdentifier:@"UNPChooseItemCell"];
}


#pragma mark - table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    return cell;
}


@end
