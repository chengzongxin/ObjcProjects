//
//  DragingViewController.m
//  ObjcProjects
//
//  Created by Joe on 2019/6/13.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "DragingViewController.h"
#import "DragView.h"

@interface DragingViewController ()

@end

@implementation DragingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    DragView *view = [[DragView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:view];
}

@end
