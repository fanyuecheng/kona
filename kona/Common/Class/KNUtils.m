//
//  KNUtils.m
//  kona
//
//  Created by 范月成 on 2018/8/21.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import "KNUtils.h"

@implementation KNUtils

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static KNUtils *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        _adultEnbled = [[NSUserDefaults standardUserDefaults] boolForKey:KNAdultEnbled];
    }
    return self;
}

- (void)setAdultEnbled:(BOOL)adultEnbled {
    _adultEnbled = adultEnbled;
    [[NSUserDefaults standardUserDefaults] setBool:adultEnbled forKey:KNAdultEnbled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

