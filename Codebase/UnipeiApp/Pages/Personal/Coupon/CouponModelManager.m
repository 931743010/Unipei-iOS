//
//  CouponModelManager.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/24.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "CouponModelManager.h"
#import "CouponModel.h"
@implementation CouponModelManager
+(NSArray *)arrayWithDic:(NSDictionary *)dict{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    NSArray *array = dict[@"UseConditionList"];
    for (NSDictionary *dic in array) {
        CouponModel *model = [[CouponModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [mArray addObject:model];
    }
    return mArray;
}
@end
