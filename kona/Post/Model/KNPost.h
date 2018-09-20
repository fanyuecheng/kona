//
//  KNPost.h
//  kona
//
//  Created by 范月成 on 2018/8/20.
//  Copyright © 2018年 fancy. All rights reserved.
//

#import "KNModel.h"
/*
 {
     id: 123760,
     tags: "bishoujo_mangekyou black_hair blue_eyes breast_grab censored cum game_cg happoubi_jin kagarino_kirie long_hair nipples no_bra omega_star onogami_shigehiko open_shirt seifuku sex short_hair tie vampire white_hair wink",
     created_at: 1325315100,
     creator_id: 33769,
     author: "Dark_Person",
     change: 1494864,
     source: "",
     score: 485,
     md5: "e860f8d9c6e7cbab443ff079b5acc6c2",
     file_size: 362017,
     file_url: "https://konachan.com/image/e860f8d9c6e7cbab443ff079b5acc6c2/Konachan.com%20-%20123760%20black_hair%20blue_eyes%20censored%20cum%20game_cg%20long_hair%20nipples%20no_bra%20omega_star%20open_shirt%20seifuku%20sex%20short_hair%20tie%20vampire%20white_hair%20wink.jpg",
     is_shown_in_index: true,
     preview_url: "https://konachan.com/data/preview/e8/60/e860f8d9c6e7cbab443ff079b5acc6c2.jpg",
     preview_width: 150,
     preview_height: 84,
     actual_preview_width: 300,
     actual_preview_height: 169,
     sample_url: "https://konachan.com/image/e860f8d9c6e7cbab443ff079b5acc6c2/Konachan.com%20-%20123760%20black_hair%20blue_eyes%20censored%20cum%20game_cg%20long_hair%20nipples%20no_bra%20omega_star%20open_shirt%20seifuku%20sex%20short_hair%20tie%20vampire%20white_hair%20wink.jpg",
     sample_width: 1280,
     sample_height: 720,
     sample_file_size: 0,
     jpeg_url: "https://konachan.com/image/e860f8d9c6e7cbab443ff079b5acc6c2/Konachan.com%20-%20123760%20black_hair%20blue_eyes%20censored%20cum%20game_cg%20long_hair%20nipples%20no_bra%20omega_star%20open_shirt%20seifuku%20sex%20short_hair%20tie%20vampire%20white_hair%20wink.jpg",
     jpeg_width: 1280,
     jpeg_height: 720,
     jpeg_file_size: 0,
     rating: "e",
     has_children: true,
     parent_id: null,
     status: "active",
     width: 1280,
     height: 720,
     is_held: false,
     frames_pending_string: "",
     frames_pending: [ ],
     frames_string: "",
     frames: [ ]
 }
*/
@class KNPost;
typedef void(^getPostCompletedBlock)(NSArray <KNPost *>*posts, NSError *error);
typedef NS_ENUM(NSInteger, KNPostPopularPeriod) {
    KNPostPopularPeriodNone,
    KNPostPopularPeriodDay,
    KNPostPopularPeriodWeek,
    KNPostPopularPeriodMonth,
    KNPostPopularPeriodYear
};

@interface KNPost : KNModel

@property (nonatomic, copy)   NSString       *tags;
@property (nonatomic, assign) NSTimeInterval created_at;
@property (nonatomic, assign) NSInteger      creator_id;
@property (nonatomic, copy)   NSString       *author;
@property (nonatomic, assign) NSInteger      change;
@property (nonatomic, copy)   NSString       *source;
@property (nonatomic, assign) NSInteger      score;
@property (nonatomic, copy)   NSString       *md5;
@property (nonatomic, assign) NSInteger      file_size;
@property (nonatomic, copy)   NSString       *file_url;
@property (nonatomic, assign) BOOL           is_shown_in_index;
@property (nonatomic, copy)   NSString       *preview_url;
@property (nonatomic, assign) NSInteger      preview_width;
@property (nonatomic, assign) NSInteger      preview_height;
@property (nonatomic, assign) NSInteger      actual_preview_width;
@property (nonatomic, assign) NSInteger      actual_preview_height;
@property (nonatomic, copy)   NSString       *sample_url;
@property (nonatomic, assign) NSInteger      sample_width;
@property (nonatomic, assign) NSInteger      sample_height;
@property (nonatomic, assign) NSInteger      sample_file_size;
@property (nonatomic, copy)   NSString       *jpeg_url;
@property (nonatomic, assign) NSInteger      jpeg_width;
@property (nonatomic, assign) NSInteger      jpeg_height;
@property (nonatomic, assign) NSInteger      jpeg_file_size;
@property (nonatomic, copy)   NSString       *rating;
@property (nonatomic, assign) BOOL           has_children;
@property (nonatomic, assign) NSInteger      parent_id;
@property (nonatomic, copy)   NSString       *status;
@property (nonatomic, assign) NSInteger      width;
@property (nonatomic, assign) NSInteger      height;
@property (nonatomic, assign) BOOL           is_held;
@property (nonatomic, copy)   NSString       *frames_pending_string;
@property (nonatomic, copy)   NSArray        *frames_pending;
@property (nonatomic, copy)   NSString       *frames_string;
@property (nonatomic, copy)   NSArray        *frames;

@property (nonatomic, copy)   NSArray        *tagsArray;
@property (nonatomic, strong) UIImage        *previewImage;
@property (nonatomic, strong) UIImage        *originalImage;

+ (void)getPostWithPage:(NSUInteger)page
              completed:(getPostCompletedBlock)completed;

+ (void)getPostWithTags:(NSString *)tags
                   page:(NSUInteger)page
              completed:(getPostCompletedBlock)completed;

+ (void)getPostWithTags:(NSString *)tags
                   page:(NSUInteger)page
                  limit:(NSUInteger)limit
              completed:(getPostCompletedBlock)completed;

+ (void)getPopularPostWithPeriod:(KNPostPopularPeriod)period
                       completed:(getPostCompletedBlock)completed;

@end
