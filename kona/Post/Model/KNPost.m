//
//  KNPost.m
//  kona
//
//  Created by 范月成 on 2018/8/20.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import "KNPost.h"
#import "KNHeader.h"

@implementation KNPost

- (NSArray *)tagsArray {
    if (self.tags.length) {
        return [self.tags componentsSeparatedByString:@" "];
    } else {
        return @[];
    }
}

- (UIImage *)previewImage {
    if (_previewImage) {
        return _previewImage;
    } else {
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.preview_url]];
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
        
        if (cachedImage) {
            _previewImage = cachedImage;
            return _previewImage;
        } else {
            __block UIImage *previewImage = nil;
 
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.preview_url] options:kNilOptions progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    previewImage = image;
                    self.previewImage = image;
                }
            }];
            return previewImage;
        }
    }
}

- (UIImage *)originalImage {
    if (_originalImage) {
        return _originalImage;
    } else {
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.jpeg_url]];
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
        
        if (cachedImage) {
            _originalImage = cachedImage;
            return _originalImage;
        } else {
            __block UIImage *originalImage = nil;
            
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.jpeg_url] options:kNilOptions progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    originalImage = image;
                    self.originalImage = image;
                }
            }];
            return originalImage;
        }
    }
}

+ (void)getPostWithPage:(NSUInteger)page
              completed:(getPostCompletedBlock)completed {
    [KNPost getPostWithTags:nil page:page completed:completed];
}

+ (void)getPostWithTags:(NSString *)tags
                   page:(NSUInteger)page
              completed:(getPostCompletedBlock)completed {
    [KNPost getPostWithTags:tags page:page limit:21  completed:completed];
}

+ (void)getPostWithTags:(NSString *)tags
                   page:(NSUInteger)page
                  limit:(NSUInteger)limit
              completed:(getPostCompletedBlock)completed {
    NSDictionary *parameters = @{
                                 @"tags" : tags ? tags : @"",
                                 @"page" : @(page),
                                 @"limit" : @(limit)
                                 };
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = KN_POST;
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = parameters;
    } onSuccess:^(id responseObject) {
        NSArray *result = [NSArray yy_modelArrayWithClass:KNPost.class json:responseObject];
        NSMutableArray *posts = [NSMutableArray array];
        
        if (![KNUtils sharedInstance].adultEnbled) {
            for (KNPost *post in result) {
                if ([post.rating isEqualToString:@"s"]) {
                    [posts addObject:post];
                }
            }
        } else {
            [posts addObjectsFromArray:result];
        }
        
        if (posts.count) {
            !completed ? : completed(posts, nil);
        } else {
            !completed ? : completed(nil, [NSError errorWithDomain:KNNoneDataErrorDomain code:KNNoneDataErrorCode userInfo:nil]);
        }
    } onFailure:^(NSError *error) {
        !completed ? : completed(nil, error);
    }];
}

+ (void)getPopularPostWithPeriod:(KNPostPopularPeriod)period
                       completed:(getPostCompletedBlock)completed {
    NSString *periodString = nil;
    switch (period) {
        case KNPostPopularPeriodDay:
            periodString = @"1d";
            break;
        case KNPostPopularPeriodWeek:
            periodString = @"1w";
            break;
        case KNPostPopularPeriodMonth:
            periodString = @"1m";
            break;
        case KNPostPopularPeriodYear:
            periodString = @"1y";
            break;
        default:
            periodString = @"1d";
            break;
    }
    
    NSDictionary *parameters = @{
                                 @"period" : periodString,
                                 };
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = KN_POST_POPULAR;
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = parameters;
    } onSuccess:^(id responseObject) {
        NSArray *result = [NSArray yy_modelArrayWithClass:KNPost.class json:responseObject];
        NSMutableArray *posts = [NSMutableArray array];
        
        if (![KNUtils sharedInstance].adultEnbled) {
            for (KNPost *post in result) {
                if ([post.rating isEqualToString:@"s"]) {
                    [posts addObject:post];
                }
            }
        } else {
            [posts addObjectsFromArray:result];
        }
        
        if (posts.count) {
            !completed ? : completed(posts, nil);
        } else {
            !completed ? : completed(nil, [NSError errorWithDomain:KNNoneDataErrorDomain code:KNNoneDataErrorCode userInfo:nil]);
        }
    } onFailure:^(NSError *error) {
        !completed ? : completed(nil, error);
    }];
}

@end
