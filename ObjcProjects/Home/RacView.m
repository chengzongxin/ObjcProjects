//
//  RacView.m
//  ObjcProjects
//
//  Created by Joe on 2019/5/27.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "RacView.h"

@implementation RacView

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(20, 20, 40, 40);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(btn.frame) + 20, 100, 44)];
    textField.placeholder = @"rac text";
    [self addSubview:textField];
    self.textSubject = [RACSubject new];
    [textField.rac_textSignal subscribe:self.textSubject];
    
}

- (void)buttonClick:(UIButton *)btn{
    [self.buttonSubject sendNext:btn];
}

@end
