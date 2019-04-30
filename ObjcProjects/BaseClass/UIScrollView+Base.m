//
//  UITableView+Base.m
//  ObjcProjects
//
//  Created by Joe on 2019/4/30.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "UIScrollView+Base.h"
#import <objc/runtime.h>
#define HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static const int  KSpaceHeight = 10;

@implementation UIScrollView (Base)

#pragma mark - Public Method

- (void)setupEmptyDataWithEmptyImage:(nullable UIImage *)emptyImage
                           emptyText:(nullable NSString *)emptyText
                   networkErrorImage:(nullable UIImage *)networkErrorImage
                    networkErrorText:(nullable NSString *)networkErrorText
                              offset:(CGFloat)offset
                            tapBlock:(nullable TapBlock)tapBlock{
    [self setupEmptyDataWithEmptyImage:emptyImage emptyText:emptyText emptyAttrText:nil networkErrorImage:networkErrorImage networkErrorText:networkErrorText networkErrorAttrText:nil offset:offset tapBlock:tapBlock];
}

- (void)setupEmptyDataWithEmptyImage:(nullable UIImage *)emptyImage
                       emptyAttrText:(nullable NSMutableAttributedString *)emptyAttrText
                   networkErrorImage:(nullable UIImage *)networkErrorImage
                networkErrorAttrText:(nullable NSMutableAttributedString *)networkErrorAttrText
                              offset:(CGFloat)offset
                            tapBlock:(nullable TapBlock)tapBlock{
    [self setupEmptyDataWithEmptyImage:emptyImage emptyText:nil emptyAttrText:emptyAttrText networkErrorImage:networkErrorImage networkErrorText:nil networkErrorAttrText:networkErrorAttrText offset:offset tapBlock:tapBlock];
}

- (void)setupEmptyDataWithEmptyImage:(nullable UIImage *)emptyImage
                           emptyText:(nullable NSString *)emptyText
                       emptyAttrText:(nullable NSMutableAttributedString *)emptyAttrText
                   networkErrorImage:(nullable UIImage *)networkErrorImage
                    networkErrorText:(nullable NSString *)networkErrorText
                networkErrorAttrText:(nullable NSMutableAttributedString *)networkErrorAttrText
                              offset:(CGFloat)offset
                            tapBlock:(nullable TapBlock)tapBlock{
    self.emptyImage = emptyImage;
    self.emptyText = emptyText;
    self.emptyAttrText = emptyAttrText;
    self.networkErrorImage = networkErrorImage;
    self.networkErrorText = networkErrorText;
    self.networkErrorAttrText = networkErrorAttrText;
    self.offset = offset;
    self.isLoading = YES;
    self.emptyDataType = EmptyDataTypeNormal;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.tapClock = tapBlock;
}

#pragma mark - DZNEmptyDataSetSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return !self.isLoading;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return KSpaceHeight;
}

// 空白界面的标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.emptyDataType == EmptyDataTypeNormal) {
        // 无数据
        if (self.emptyAttrText) {
            return self.emptyAttrText;
        }else{
            NSString *text = self.emptyText?:@"暂无数据";
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
            return attrString;
        }
    }else{
        // 无网络
        if (self.networkErrorAttrText) {
            return self.networkErrorAttrText;
        }else{
            NSString *text = self.networkErrorText?:@"网络异常";
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
            return attrString;
        }
    }
    return [[NSMutableAttributedString alloc] initWithString:@"暂无数据"];
}

// 空白页的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *img = self.emptyDataType == EmptyDataTypeNormal ? self.emptyImage : self.networkErrorImage;
    if (!img) {
        img = self.emptyDataType == EmptyDataTypeNormal ? [UIImage imageNamed:@"nodata"] : [UIImage imageNamed:@"nonetwork"];
    }
    return img;
}

//- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView{
//    scrollView.scrollEnabled = YES;
//}

//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

// 垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.offset;
}


#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if (self.tapClock) {
        self.tapClock();
    }
}



#pragma mark - Getter Setter
- (TapBlock)tapClock{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTapClock:(TapBlock)tapClock{
    objc_setAssociatedObject(self, @selector(tapClock), tapClock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIImage *)emptyImage{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEmptyImage:(UIImage *)emptyImage{
    objc_setAssociatedObject(self, @selector(emptyImage), emptyImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptyText{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEmptyText:(NSString *)emptyText{
    objc_setAssociatedObject(self, @selector(emptyText), emptyText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableAttributedString *)emptyAttrText{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEmptyAttrText:(NSMutableAttributedString *)emptyAttrText{
    objc_setAssociatedObject(self, @selector(emptyAttrText), emptyAttrText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)networkErrorImage{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNetworkErrorImage:(UIImage *)networkErrorImage{
    objc_setAssociatedObject(self, @selector(networkErrorImage), networkErrorImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)networkErrorText{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNetworkErrorText:(NSString *)networkErrorText{
    objc_setAssociatedObject(self, @selector(networkErrorText), networkErrorText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableAttributedString *)networkErrorAttrText{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNetworkErrorAttrText:(NSMutableAttributedString *)networkErrorAttrText{
    objc_setAssociatedObject(self, @selector(networkErrorAttrText), networkErrorAttrText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)offset{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number.floatValue;
}

- (void)setOffset:(CGFloat)offset{
    NSNumber *number = [NSNumber numberWithDouble:offset];
    objc_setAssociatedObject(self, @selector(offset), number, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isLoading{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number.boolValue;
}

- (void)setIsLoading:(BOOL)isLoading{
    NSNumber *num = [NSNumber numberWithBool:isLoading];
    objc_setAssociatedObject(self, @selector(isLoading), num, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEmptyDataType:(EmptyDataType)emptyDataType{
    NSNumber *type = [NSNumber numberWithInt:emptyDataType];
    objc_setAssociatedObject(self, @selector(emptyDataType), type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EmptyDataType)emptyDataType{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}


@end
