//
//  MessageViewController.m
//  NavigationBarDemo
//
//  Created by Joe on 2019/4/23.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "MessageViewController.h"
#import <ReactiveObjC.h>
#import "UIScrollView+RefreshController.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_datas;
}
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation MessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datas = [NSMutableArray arrayWithObjects:@"123",@"123",@"123",@"123",@"123",@"123",@"123", nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView addRefreshWithTarget:self headerSelector:@selector(headerRefresh) footerSelect:@selector(footerRefresh)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(_add)];
    
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, -88, self.view.frame.size.width, 88)];
//    header.backgroundColor = UIColor.orangeColor;
//    [self.tableView addSubview:header];
//
//
//    UIView *footer = [[UIView alloc] init];
//    footer.backgroundColor = UIColor.greenColor;
//    footer.layer.zPosition = -1;
//    [self.tableView addSubview:footer];
//
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 20, self.view.frame.size.width, 20);
//    label.text = @"----已经到底啦----";
//    label.textAlignment = NSTextAlignmentCenter;
//    [footer addSubview:label];
    
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 88, 0);
//    [RACObserve(self.tableView, contentSize) subscribeNext:^(id  _Nullable x) {
//        CGSize size = [x CGSizeValue];
//        footer.frame = CGRectMake(0, size.height, self.view.frame.size.width, 88);
//    }];
    
    
    //    RACSignal *button1Singnal = [[self.button1 rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id _Nullable(__kindof UIControl * _Nullable value) {
    //        NSLog(@"button1 = %@",value);
    //        return [NSDate date];
    //    }];
}

- (void)headerRefresh{
    NSLog(@"%s",__FUNCTION__);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView stopRefresh];
    });
}
// test
- (void)footerRefresh{
    NSLog(@"%s",__FUNCTION__);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _add];
        [self.tableView stopRefresh];
    });
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)_add{
    [_datas addObject:@"123"];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = _datas[indexPath.row];
    return cell;
}

@end
