//
//  KNViewController.m
//  kona
//
//  Created by 范月成 on 2018/8/20.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import "KNViewController.h"

@interface KNViewController ()

@end

@implementation KNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didInitialize {
    [super didInitialize];
    
    if (@available(iOS 13.0, *)) {
       self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
