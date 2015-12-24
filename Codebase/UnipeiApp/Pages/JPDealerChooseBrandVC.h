//
//  JPDealerChooseBrandVC.h
//  DymIOSApp
//
//  Created by MacBook on 11/19/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"
#import "UNPCarModelChooseVM.h"
#import "JPLazyBlock.h"


@interface JPDealerChooseBrandVC : DymBaseVC


@property (nonatomic, strong, readonly) JPLazyBlock   *lazyBlock;

@property (nonatomic, strong, readonly) NSMutableDictionary        *allBrands;
@property (nonatomic, strong, readonly) NSArray                    *sectionTitles;

@end
