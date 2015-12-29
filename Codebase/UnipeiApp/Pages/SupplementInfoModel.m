//
//  SupplementInfoModel.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/27.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "SupplementInfoModel.h"

@implementation SupplementInfoModel
+(NSArray *)arrayWithInfo{
    return @[@"修理厂名称：",@"地址：",@"手机号：",@"座机号：",@"邮箱*：",@"成立年份：",@"店铺面积：",@"工位数：",@"技师人数：",@"停车位数：",@"机构照片："];
}
+(NSArray *)arrayWithArea{
     return @[@"小于100m²",@"100m²-200m²",@"200m²-300m²",@"300m^2-400m^2",@"400m^2-500m^2",@"500m²以上"];
}
+(NSArray *)arrayWithFactoryType{
     return @[@"1-5",@"6-10",@"11-15",@"16-20"];
}
+(NSArray *)arrayWithYear{
    NSMutableArray *yearArr = [[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    for (int i=0; i<20; i++) {
        NSString *year = [NSString stringWithFormat:@"%ld年",[dateComponent year]-i ];
        [yearArr addObject:year];
    }
    return yearArr;
}
+(NSArray *)arrayWithUsurInfo:(NSDictionary *)dic {
  //  NSMutableArray *mArray = [[NSMutableArray alloc]init];
    return @[dic[@"organName"],dic[@"address"],dic[@"phone"]];
}
@end
