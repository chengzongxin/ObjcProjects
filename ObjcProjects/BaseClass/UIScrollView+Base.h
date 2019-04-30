//
//  UITableView+Base.h
//  ObjcProjects
//
//  Created by Joe on 2019/4/30.
//  Copyright © 2019 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    EmptyDataTypeNormal = 1,
    EmptyDataTypeNetworkError
}EmptyDataType;

@interface UIScrollView (Base)<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

typedef void(^TapBlock)(void);
@property (copy, nonatomic)     TapBlock            tapClock;                   // 点击事件
@property (assign, nonatomic)   CGFloat             offset;                     // 垂直偏移量

@property (strong, nonatomic)   UIImage                                 *emptyImage;                    // 空数据的图片
@property (strong, nonatomic)   NSString                                *emptyText;                     // 空数据显示内容
@property (strong, nonatomic)   NSMutableAttributedString               *emptyAttrText;                 // 空数据显示内容

@property (strong, nonatomic)   UIImage                                 *networkErrorImage;             // 无网数据的图片
@property (strong, nonatomic)   NSString                                *networkErrorText;              // 无网数数据显示内容
@property (strong, nonatomic)   NSMutableAttributedString               *networkErrorAttrText;          // 无网数数据显示内容

@property (assign, nonatomic)   BOOL                isLoading;                  // 是否正在加载,如果在加载就不显示
@property (assign, nonatomic)   EmptyDataType       emptyDataType;              // 空数据类型,无网 or nodata


/**
 设置无数据 & 无网络界面
 
 @param emptyImage 无数据图片
 @param emptyText 无数据文本 和 无数据富文本 只有一个生效,优先使用富文本
 @param networkErrorImage 无网络图片
 @param networkErrorText 无网络文本 和 无网络富文本 只有一个生效,优先使用富文本
 @param offset 图片和文字偏移
 @param tapBlock 点击回调
 */
- (void)setupEmptyDataWithEmptyImage:(nullable UIImage *)emptyImage
                           emptyText:(nullable NSString *)emptyText
                   networkErrorImage:(nullable UIImage *)networkErrorImage
                    networkErrorText:(nullable NSString *)networkErrorText
                              offset:(CGFloat)offset
                            tapBlock:(nullable TapBlock)tapBlock;

/**
 设置无数据 & 无网络界面
 
 @param emptyImage 无数据图片
 @param emptyAttrText 无数据富文本
 @param networkErrorImage 无网络图片
 @param networkErrorAttrText 无网络富文本
 @param offset 图片和文字偏移
 @param tapBlock 点击回调
 */
- (void)setupEmptyDataWithEmptyImage:(nullable UIImage *)emptyImage
                       emptyAttrText:(nullable NSMutableAttributedString *)emptyAttrText
                   networkErrorImage:(nullable UIImage *)networkErrorImage
                networkErrorAttrText:(nullable NSMutableAttributedString *)networkErrorAttrText
                              offset:(CGFloat)offset
                            tapBlock:(nullable TapBlock)tapBlock;


/**
 设置无数据 & 无网络界面
 
 @param emptyImage 无数据图片
 @param emptyText 无数据文本 和 无数据富文本 只有一个生效,优先使用富文本
 @param emptyAttrText 无数据富文本
 @param networkErrorImage 无网络图片
 @param networkErrorText 无网络文本 和 无网络富文本 只有一个生效,优先使用富文本
 @param networkErrorAttrText 无网络富文本
 @param offset 图片和文字偏移
 @param tapBlock 点击回调
 */
- (void)setupEmptyDataWithEmptyImage:(nullable UIImage *)emptyImage
                           emptyText:(nullable NSString *)emptyText
                       emptyAttrText:(nullable NSMutableAttributedString *)emptyAttrText
                   networkErrorImage:(nullable UIImage *)networkErrorImage
                    networkErrorText:(nullable NSString *)networkErrorText
                networkErrorAttrText:(nullable NSMutableAttributedString *)networkErrorAttrText
                              offset:(CGFloat)offset
                            tapBlock:(nullable TapBlock)tapBlock;


@end

NS_ASSUME_NONNULL_END
