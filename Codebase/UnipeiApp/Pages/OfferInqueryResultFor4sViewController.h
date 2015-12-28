//
//  OfferInqueryResultFor4sViewController.h
//  DymIOSApp
//
//  Created by MacBook on 12/25/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferInqueryResultFor4sViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *allfoursList;
@property (strong, nonatomic) NSString *titleContent;

@end
