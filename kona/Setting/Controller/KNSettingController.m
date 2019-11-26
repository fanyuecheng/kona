//
//  KNSettingController.m
//  kona
//
//  Created by 范月成 on 2018/8/21.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import "KNSettingController.h"

@interface KNSettingController ()

@property (nonatomic, strong) QMUIStaticTableViewCellDataSource *dataSource;

@end

@implementation KNSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_closeItemWithTarget:self action:@selector(closeAction:)];
}

- (void)initTableView {
    [super initTableView];
    
    self.tableView.qmui_staticCellDataSource = self.dataSource;
}

#pragma mark - Action
- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchAction:(UISwitch *)sender {
    [KNUtils sharedInstance].adultEnbled = sender.on;
}

- (void)clearAction:(QMUIStaticTableViewCellData *)data {
    QMUIAlertController *alertController = [[QMUIAlertController alloc] initWithTitle:@"清除缓存？" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    
    QMUIAlertAction *save = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        QMUITips *loading = [QMUITips showLoadingInView:self.view];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [loading hideAnimated:YES];
            data.detailText = [NSByteCountFormatter stringFromByteCount:[[SDImageCache sharedImageCache] totalDiskSize] countStyle:NSByteCountFormatterCountStyleFile];
            [self.tableView reloadRowsAtIndexPaths:@[data.indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }];
    
    QMUIAlertAction *cancel = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:save];
    [alertController addAction:cancel];
    
    [alertController showWithAnimated:YES];
 
    [self.tableView deselectRowAtIndexPath:data.indexPath animated:YES];
}

#pragma mark - QMUINavigationControllerAppearanceDelegate

- (UIColor *)titleViewTintColor {
    return UIColorBlue;
}
 
- (UIColor *)navigationBarTintColor {
    return UIColorBlue;
}

#pragma mark - Get
- (QMUIStaticTableViewCellDataSource *)dataSource {
    if (!_dataSource) {
        QMUIStaticTableViewCellData *data0 = [QMUIStaticTableViewCellData staticTableViewCellDataWithIdentifier:0 image:nil text:@"R18" detailText:nil didSelectTarget:nil didSelectAction:nil accessoryType:QMUIStaticTableViewCellAccessoryTypeSwitch];
        data0.accessoryValueObject = [NSNumber numberWithBool:[KNUtils sharedInstance].adultEnbled];
        data0.accessoryTarget = self;
        data0.accessoryAction = @selector(switchAction:);
        
        NSString *fileSize = [NSByteCountFormatter stringFromByteCount:[[SDImageCache sharedImageCache] totalDiskSize] countStyle:NSByteCountFormatterCountStyleFile];
        NSString *detailText = [NSString stringWithFormat:@"%lu个 %@", [[SDImageCache sharedImageCache] totalDiskCount], fileSize];
        
        QMUIStaticTableViewCellData *data1 = [QMUIStaticTableViewCellData staticTableViewCellDataWithIdentifier:1 image:nil text:@"清除缓存" detailText:detailText didSelectTarget:self didSelectAction:@selector(clearAction:) accessoryType:QMUIStaticTableViewCellAccessoryTypeNone];
        data1.style = UITableViewCellStyleValue1;
 
        _dataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[@[data0, data1]]];
    }
    return _dataSource;
}


@end
