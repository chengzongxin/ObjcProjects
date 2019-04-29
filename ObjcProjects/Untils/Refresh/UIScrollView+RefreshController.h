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

NS_ASSUME_NONNULL_BEGIN
//刷新状态枚举

@interface UIScrollView (RefreshController)

@property (strong, nonatomic) RefreshHeader *header;
@property (strong, nonatomic) RefreshFooter *footer;

- (void)addRefreshWithTarget:(id)target headerSelector:(SEL)headerSelector footerSelect:(SEL)footerSelect;
// 开始刷新
-(void)startRefresh;
// 结束刷新
-(void)stopRefresh;
@end

NS_ASSUME_NONNULL_END
