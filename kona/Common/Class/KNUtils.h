//
//  KNUtils.h
//  kona
//
//  Created by 范月成 on 2018/8/21.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KNAdultEnbled @"R18_Enable"
@interface KNUtils : NSObject

@property (nonatomic, assign, getter=isAdultEnbled) BOOL adultEnbled;

+ (instancetype)sharedInstance;

@end
