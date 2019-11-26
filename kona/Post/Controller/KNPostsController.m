//
//  KNPostsController.m
//  kona
//
//  Created by 范月成 on 2018/8/21.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import "KNPostsController.h"
#import "KNPostViewModel.h"
#import "KNSettingController.h"

@interface KNPostsController () <QMUIImagePreviewViewDelegate, UISearchBarDelegate, QMUINavigationTitleViewDelegate>

@property (nonatomic, strong) QMUISearchBar              *searchBar;
@property (nonatomic, strong) UICollectionView           *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic, strong) KNPostViewModel            *viewModel;
@property (nonatomic, strong) QMUIImagePreviewViewController *previewController;
@property (nonatomic, strong) QMUIPopupMenuView          *menuView;

@end

@implementation KNPostsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showEmptyViewWithLoading];
    [self.viewModel getRandomPost];
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.collectionView];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.title = @"konachan";
    self.titleView.userInteractionEnabled = YES;
    self.titleView.delegate = self;
  
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"设置" target:self action:@selector(settingAction:)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat navigationHeight = self.qmui_navigationBarMaxYInViewCoordinator;
    CGFloat safeAreaBottom = SafeAreaInsetsConstantForDeviceWithNotch.bottom;
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(navigationHeight);
        make.left.width.equalTo(self.view);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-safeAreaBottom);
    }];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}

- (BOOL)layoutEmptyView {
    if (self.emptyView) {
        BOOL viewDidLoad = self.emptyView.superview && [self isViewLoaded];
        if (viewDidLoad) {
            CGFloat searchBarH = IOS_VERSION < 11.0 ? 44 : 56;
            CGFloat y = self.qmui_navigationBarMaxYInViewCoordinator + searchBarH;
            CGFloat h = self.view.qmui_height - y - SafeAreaInsetsConstantForDeviceWithNotch.bottom;
            self.emptyView.frame = CGRectMake(0, y, self.view.qmui_width, h);
            return YES;
        }
    }
    return NO;
}

#pragma mark - Action
- (void)settingAction:(id)sender {
    KNNavigationController *setting = [[KNNavigationController alloc] initWithRootViewController:[[KNSettingController alloc] initWithStyle:UITableViewStyleGrouped]];
    [self presentViewController:setting animated:YES completion:nil];
}

#pragma mark - QMUIImagePreviewViewDelegate
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return self.viewModel.posts.count;
}
- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {

    zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    KNPost *post = self.viewModel.posts[index];
    if (post.originalImage) {
        zoomImageView.image = post.originalImage;
    } else {
        [zoomImageView showLoading];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:post.jpeg_url] options:kNilOptions progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [zoomImageView hideEmptyView];
            zoomImageView.image = image;
        }];
    }
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    [self.previewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)longPressInZoomingImageView:(QMUIZoomImageView *)zoomImageView {
    QMUIAlertController *alertController = [[QMUIAlertController alloc] initWithTitle:@"存入相册" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    
    QMUIAlertAction *save = [QMUIAlertAction actionWithTitle:@"保存" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        QMUIImageWriteToSavedPhotosAlbumWithAlbumAssetsGroup(zoomImageView.image, nil, ^(QMUIAsset *asset, NSError *error) {
            NSString *alert = error ? error.domain : @"已存入相册";
            [QMUITips showWithText:alert inView:self.previewController.view];
        });
    }];
    
    QMUIAlertAction *cancel = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:save];
    [alertController addAction:cancel];
    
    [alertController showWithAnimated:YES];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self showEmptyViewWithLoading];
    [self.viewModel getPostWithTags:searchBar.text];
}

#pragma mark - QMUINavigationTitleViewDelegate
- (void)didTouchTitleView:(QMUINavigationTitleView *)titleView isActive:(BOOL)isActive {
    [self.menuView showWithAnimated:YES];
}

#pragma mark - QMUINavigationControllerAppearanceDelegate

- (UIColor *)titleViewTintColor {
    return UIColorBlue;
}
 
- (UIColor *)navigationBarTintColor {
    return UIColorBlue;
}

#pragma mark - Get
- (QMUISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[QMUISearchBar alloc] init];
        _searchBar.backgroundImage = [UIImage qmui_imageWithColor:UIColorWhite];
        _searchBar.placeholder = @"搜索";
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.qmui_textField.backgroundColor = UIColorMakeWithRGBA(155, 155, 155, 0.15);
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        _collectionView.backgroundColor = UIColorWhite;
        _collectionView.dataSource = self.viewModel;
        _collectionView.delegate = self.viewModel;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
        @weakify(self)
        _collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel getNextPage];
        }];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewLayout {
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        _collectionViewLayout.minimumLineSpacing = 1;
        _collectionViewLayout.minimumInteritemSpacing = 1;
        _collectionViewLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 4) / 3, (SCREEN_WIDTH - 4) / 3);
    }
    return _collectionViewLayout;
}

- (KNPostViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[KNPostViewModel alloc] init];
        @weakify(self)
        _viewModel.reloadBlock = ^(NSError *error) {
            @strongify(self)
            [self hideEmptyView];
            if (error.code == KNNoneDataErrorCode) {
                if (!self.viewModel.posts.count) {
                    [self showEmptyViewWithText:@"无数据" detailText:nil buttonTitle:nil buttonAction:nil];
                }
                
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
            if (self.viewModel.period == KNPostPopularPeriodNone) {
                self.collectionView.mj_footer.hidden = !self.viewModel.posts.count;
            } else {
                self.collectionView.mj_footer.hidden = YES;
            }
 
            [self.collectionView reloadData];
        };
        _viewModel.selectedBlock = ^(NSIndexPath *indexPath, KNPost *post) {
            @strongify(self)
            self.previewController = [[QMUIImagePreviewViewController alloc] init];
            self.previewController.imagePreviewView.delegate = self;
            self.previewController.imagePreviewView.currentImageIndex = indexPath.item;
            [self presentViewController:self.previewController animated:YES completion:nil];
        };
    }
    return _viewModel;
}

- (QMUIPopupMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[QMUIPopupMenuView alloc] init];
        _menuView.automaticallyHidesWhenUserTap = YES;
        _menuView.maskViewBackgroundColor = [UIColor clearColor];
        _menuView.backgroundColor = UIColorWhite;
        _menuView.maximumWidth = 108;
        _menuView.shouldShowItemSeparator = YES;
        _menuView.itemSeparatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _menuView.itemSeparatorColor = UIColorSeparator;
        _menuView.cornerRadius = 6;
        _menuView.borderWidth = 0;
        _menuView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
        
        @weakify(self)
        QMUIPopupMenuButtonItem *item0 = [self popupMenuItemWithTitle:@"随机" handler:^(QMUIPopupMenuButtonItem *aItem) {
            @strongify(self)
            [aItem.menuView hideWithAnimated:YES];
            [self showEmptyViewWithLoading];
            [self.viewModel getRandomPost];
        }];
        QMUIPopupMenuButtonItem *item1 = [self popupMenuItemWithTitle:@"1天" handler:^(QMUIPopupMenuButtonItem *aItem) {
            @strongify(self)
            [aItem.menuView hideWithAnimated:YES];
            [self showEmptyViewWithLoading];
            [self.viewModel getPopoluarPostWithPeriod:KNPostPopularPeriodDay];
        }];
        QMUIPopupMenuButtonItem *item2 = [self popupMenuItemWithTitle:@"1周" handler:^(QMUIPopupMenuButtonItem *aItem) {
            @strongify(self)
            [aItem.menuView hideWithAnimated:YES];
            [self showEmptyViewWithLoading];
            [self.viewModel getPopoluarPostWithPeriod:KNPostPopularPeriodWeek];
        }];
        QMUIPopupMenuButtonItem *item3 = [self popupMenuItemWithTitle:@"1月" handler:^(QMUIPopupMenuButtonItem *aItem) {
            @strongify(self)
            [aItem.menuView hideWithAnimated:YES];
            [self showEmptyViewWithLoading];
            [self.viewModel getPopoluarPostWithPeriod:KNPostPopularPeriodMonth];
        }];
        QMUIPopupMenuButtonItem *item4 = [self popupMenuItemWithTitle:@"1年" handler:^(QMUIPopupMenuButtonItem *aItem) {
            @strongify(self)
            [aItem.menuView hideWithAnimated:YES];
            [self showEmptyViewWithLoading];
            [self.viewModel getPopoluarPostWithPeriod:KNPostPopularPeriodYear];
        }];
        
        _menuView.items = @[item0, item1, item2, item3, item4];
        _menuView.sourceView = self.titleView;
    }
    return _menuView;
}

- (QMUIPopupMenuButtonItem *)popupMenuItemWithTitle:(NSString *)title
                                            handler:(void (^)( QMUIPopupMenuButtonItem *aItem))handler {
    QMUIPopupMenuButtonItem *item = [QMUIPopupMenuButtonItem itemWithImage:nil title:title handler:handler];
    item.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return item;
}
 
@end
