//
//  RefreshHeader.h
//  ObjcProjects
//
//  Created by Joe on 2019/4/29.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "RefreshBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefreshHeader : RefreshBaseView
// 开始刷新
-(void)startRefresh;
// 结束刷新
-(void)stopRefresh;

@end

NS_ASSUME_NONNULL_END
