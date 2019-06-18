//
//  UIScrollView+RefreshController.h
//  ObjcProjects
//
//  Created by Joe on 2019/4/29.
//  Copyright © 2019 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHeader.h"
#import "RefreshFooter.h"

#import "LoadMoreControl.h"

NS_ASSUME_NONNULL_BEGIN
//刷新状态枚举

@interface UIScrollView (RefreshController)

@property (strong, nonatomic) RefreshHeader *header;
@property (strong, nonatomic) RefreshFooter *footer;

@property (strong, nonatomic) LoadMoreControl *loadMore;

- (void)addRefreshWithHeaderBlock:(RefreshingBlock)headerBlock footerBlock:(RefreshingBlock)footerBlock;

- (void)addRefreshWithTarget:(id)target headerSelector:(nullable SEL)headerSelector footerSelect:(nullable SEL)footerSelect;
// 开始刷新
- (void)headerStartRefresh;
// 结束刷新
- (void)headerStopRefresh;

- (void)footerStartRefresh;

- (void)footerStopRefresh;
@end

NS_ASSUME_NONNULL_END
