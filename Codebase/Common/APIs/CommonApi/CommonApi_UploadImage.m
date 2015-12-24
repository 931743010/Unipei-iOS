//
//  CommonApi_UploadImage.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "CommonApi_UploadImage.h"
#import "UIImage+Scale.h"
#import <ReactiveCocoa/RACEXTScope.h>

@implementation CommonApi_UploadImage

-(NSString *)requestUrl {
    return PATH_commonApi_uploadImage;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 240;
}

- (AFConstructingBlock)constructingBodyBlock {
    
    @weakify(self)
    return ^(id<AFMultipartFormData> formData) {
        
        @strongify(self)
        NSString *path = [self path];
        [formData appendPartWithFormData:[path dataUsingEncoding:NSUTF8StringEncoding] name:@"path"];
        [formData appendPartWithFormData:[self.name dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
        
        NSData *data;
        NSString *fileType;
        NSString *mimeType;
        
        if (_fileType == kJPUploadFileTypeJPEG) {
            fileType = @"jpg";
            mimeType = @"image/jpeg";
            
            UIImage *scaledImage = [self.image scaleToFitSize:[UIScreen mainScreen].bounds.size];
            data = [scaledImage compressToMaxBytes:500000]; // 500k
        } else if (_fileType == kJPUploadFileTypeAMR) {
            fileType = @"amr";
            mimeType = @"audio/AMR";
            data = _audioData;
        }
        
        if (data != nil && fileType.length > 0 && mimeType.length > 0) {
            [formData appendPartWithFileData:data name:@"file" fileName:fileType mimeType:mimeType];
        }
    };
}

-(NSString *)path {
    NSString *path = [[self pathMap] objectForKey:_pathType];
    
    NSDateFormatter *dtFmt = [[NSDateFormatter alloc] init];
    dtFmt.dateFormat = @"yyyyMMdd";
    NSString *dateStr = [dtFmt stringFromDate:[NSDate date]];
    path = [path stringByAppendingPathComponent:dateStr];
    path = [path stringByAppendingString:@"/"];
    return path;
}

-(NSString *)pathWithName {
    return [[[self path] stringByAppendingPathComponent:[self name]] stringByAppendingPathExtension:@"jpg"];
}

-(NSDictionary *)pathMap {
    return @{
             @(kServerUploadPathDealerLicence): @"dealer/BLPoto_upload"
             , @(kServerUploadPathDealerOffice): @"dealer/ShopPoto_upload"
             , @(kServerUploadPathDealerLogo): @"dealer/LogoPoto_upload"
             , @(kServerUploadPathDealerQuotation): @"dealer/quotation"
             
             , @(kServerUploadPathAvatar): @"servicer/avatar_upload"
             , @(kServerUploadPathShopLicence): @"servicer/BLPoto_upload"
             , @(kServerUploadPathShopOffice): @"servicer/ShopPoto_upload"
             , @(kServerUploadPathShopNamecard): @"servicer/TakePoto_upload"
             , @(kServerUploadPathShopInquiryPhoto): @"servicer/inquiry/photo"
             , @(kServerUploadPathShopInquiryAudio): @"servicer/inquiry/audio"
             , @(kServerUploadPathShopDemandPhoto): @"servicer/demand/photo"
             , @(kServerUploadPathShopDemandAudio): @"servicer/demand/audio"
             
             , @(kServerUploadPathManAvatar): @"repairman/avatar_upload"
             , @(kServerUploadPathCustomerServiceInquiry): @"Kefu/inquiry"
             };
}


-(Class)responseModelClass {
    return [CommonApi_UploadImage_Result class];
}


@end


@implementation CommonApi_UploadImage_Result

+(NSDictionary *) jsonMap {
    return @{
             @"picPath": @"body.picPath"
             };
}
@end
