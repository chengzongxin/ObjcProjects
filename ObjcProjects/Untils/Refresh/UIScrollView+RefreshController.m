//
//  UIScrollView+RefreshController.m
//  ObjcProjects
//
//  Created by Joe on 2019/4/29.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "UIScrollView+RefreshController.h"
#import "RefreshHeader.h"
#import "RefreshFooter.h"
#import "RefreshConstant.h"
#import <objc/runtime.h>

@implementation UIScrollView (RefreshController)


- (void)addRefreshWithTarget:(id)target headerSelector:(SEL)headerSelector footerSelect:(SEL)footerSelect{
    //添加头部刷新
    if (headerSelector) {
        RefreshHeader *header = [[RefreshHeader alloc] initWithFrame:CGRectMake(0, -K_HEADER_HEIGHT, self.bounds.size.width, K_HEADER_HEIGHT)];
        header.target = target;
        header.selector = headerSelector;
        [self addSubview:header];
        self.header = header;
    }
    //添加尾部刷新
    if (footerSelect) {
        RefreshFooter *footer = [[RefreshFooter alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, K_FOOTER_HEIGHT)];
        footer.target = target;
        footer.selector = headerSelector;
        [self addSubview:footer];
        self.footer = footer;
    }
}

- (void)startRefresh{
    [self.header startRefresh];
}

- (void)stopRefresh{
    [self.header stopRefresh];
}

- (void)setHeader:(RefreshHeader *)header{
    objc_setAssociatedObject(self,@selector(header),header,OBJC_ASSOCIATION_RETAIN);
}

- (RefreshHeader *)header{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFooter:(RefreshFooter *)footer{
    objc_setAssociatedObject(self,@selector(footer),footer,OBJC_ASSOCIATION_RETAIN);
}

- (RefreshFooter *)footer{
    return objc_getAssociatedObject(self, _cmd);
}

@end
