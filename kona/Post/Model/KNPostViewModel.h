//
//  KNPostViewModel.h
//  kona
//
//  Created by 范月成 on 2018/8/21.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNPost.h"

@interface KNPostViewModel : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong, readonly) NSMutableArray <KNPost *> *posts;
@property (nonatomic, assign, readonly) NSUInteger                page;
@property (nonatomic, assign, readonly) NSUInteger                limit;
@property (nonatomic, copy, readonly)   NSString                  *tags;
@property (nonatomic, assign, readonly) KNPostPopularPeriod       period;

@property(nonatomic, copy) void (^reloadBlock)(NSError *error);
@property(nonatomic, copy) void (^selectedBlock)(NSIndexPath *indexPath, KNPost *post);

- (void)getPostWithTags:(NSString *)tags;
- (void)getPopoluarPostWithPeriod:(KNPostPopularPeriod)period;

- (void)getNextPage;
- (void)getLastPage;
- (void)getRandomPost;

@end
