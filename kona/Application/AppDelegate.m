//
//  AppDelegate.m
//  kona
//
//  Created by 范月成 on 2018/8/20.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import "AppDelegate.h"
#import "KNHeader.h"
#import "KNNavigationController.h"
#import "KNPostsController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configNetwork];
    
    [self configWindow];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - Private Method
- (void)configWindow {
    self.window.rootViewController = [[KNNavigationController alloc] initWithRootViewController:[[KNPostsController alloc] init]];
    [self.window makeKeyAndVisible];
}

- (void)configNetwork {
    [XMCenter setupConfig:^(XMConfig *config) {
        config.generalServer = KN_HOST;
        config.callbackQueue = dispatch_get_main_queue();
        config.engine = [XMEngine sharedEngine];
#ifdef DEBUG
        config.consoleLog = YES;
#endif
    }];
}

#pragma mark - Get
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

@end
