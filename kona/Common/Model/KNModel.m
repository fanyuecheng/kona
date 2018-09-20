//
//  KNModel.m
//  kona
//
//  Created by 范月成 on 2018/8/20.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import "KNModel.h"
#import <YYModel/YYModel.h>

NSInteger const KNNoneDataErrorCode = -99999;
NSString *const KNNoneDataErrorDomain = @"KNNoneDataErrorDomain";

@implementation KNModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelId" : @"id"};
}

@end
