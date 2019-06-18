//
//  RefreshBaseView.h
//  ObjcProjects
//
//  Created by Joe on 2019/4/29.
//  Copyright © 2019 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshConstant.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    
    RefreshStatusNormal = 1,  // 正常状态
    
    RefreshStatusPrepareRefresh, // 准备刷新
    
    RefreshStatusRefreshing,  // 正在刷新
    
    RefreshStatusFinish, // 刷新完成
    
} RefreshStatus;

/** 进入刷新状态的回调 */
typedef void (^RefreshingBlock)(void);

@interface RefreshBaseView : UIView

@property (assign, nonatomic) RefreshStatus status;

@property (nonatomic,strong) UIScrollView   *superScrollView;   //父视图（表格scrollView）
@property (nonatomic,assign) CGFloat        superScrollViewContentOffY;        //父视图的偏移量
@property (nonatomic,assign) CGSize         superScrollViewContentSize;        //父视图的大小

@property (weak, nonatomic) id target;

@property (assign, nonatomic) SEL selector;

@property (copy, nonatomic) RefreshingBlock refreshingBlock;

// 开始刷新
-(void)startRefresh;
// 结束刷新
-(void)stopRefresh;

@end

NS_ASSUME_NONNULL_END
