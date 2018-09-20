//
//  KNPostViewModel.m
//  kona
//
//  Created by 范月成 on 2018/8/21.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import "KNPostViewModel.h"
#import "KNHeader.h"

@implementation KNPostViewModel

- (instancetype)init {
    if (self = [super init]) {
        _page = 1;
        _limit = 21;
        _posts = [NSMutableArray array];
        _period = KNPostPopularPeriodNone;
    }
    return self;
}

- (void)getPostWithTags:(NSString *)tags {
    if (!tags) {
        tags = @"";
    }
    if (![_tags isEqualToString:tags]) {
        _page = 1;
        _tags = tags;
    }
    
    if (_period != KNPostPopularPeriodNone) {
        _period = KNPostPopularPeriodNone;
    }
    
    @weakify(self)
    [KNPost getPostWithTags:_tags page:_page limit:_limit completed:^(NSArray<KNPost *> *posts, NSError *error) {
        @strongify(self)
        if (self.page == 1 && self.posts.count) {
            [self.posts removeAllObjects];
        }
    
        if (posts.count) {
            [self.posts addObjectsFromArray:posts];
        }
        !self.reloadBlock ? : self.reloadBlock(error);
    }];
}
- (void)getPopoluarPostWithPeriod:(KNPostPopularPeriod)period {
    _period = period;
    [KNPost getPopularPostWithPeriod:period completed:^(NSArray<KNPost *> *posts, NSError *error) {
        if (!error) {
            !self.posts.count ? : [self.posts removeAllObjects];
            [self.posts addObjectsFromArray:posts];
        }
        !self.reloadBlock ? : self.reloadBlock(error);
    }];
}

- (void)getNextPage {
    _page ++;
    [self getPostWithTags:_tags];
}

- (void)getLastPage {
    _page --;
    if (_page <= 0) {
        _page = 1;
    }
    [self getPostWithTags:_tags];
}

- (void)getRandomPost {
    _page = 1;
    [self getPostWithTags:@"order:random"];
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNPost *post = self.posts[indexPath.item];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageView = [cell.contentView viewWithTag:1000];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 4) / 3, (SCREEN_WIDTH - 4) / 3)];
        imageView.tag = 1000;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [cell.contentView addSubview:imageView];
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:post.preview_url] placeholderImage:[UIImage qmui_imageWithColor:UIColorMake(248, 248, 248)]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KNPost *post = self.posts[indexPath.item];
    !self.selectedBlock ? : self.selectedBlock(indexPath, post);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
