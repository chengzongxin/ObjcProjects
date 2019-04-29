//
//  RefreshBaseView.m
//  ObjcProjects
//
//  Created by Joe on 2019/4/29.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "RefreshBaseView.h"

@implementation RefreshBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = RefreshStatusNormal;
    }
    return self;
}

@end
