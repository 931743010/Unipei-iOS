//
//  DymBaseModel.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/1.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface DymBaseModel : MTLModel <MTLJSONSerializing>

/// basic json key paths for all models
+(NSDictionary *) baseJSONKeyPathsByPropertyKey;

/// for subclass to overwrite, defining its own json-to-property map
+(NSDictionary *) jsonMap;

@end
