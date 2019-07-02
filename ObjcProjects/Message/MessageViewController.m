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

#import "UIScrollView+RefreshController.h"
#import "UIViewController+HBD.h"
#import "UIScrollView+Base.h"
#import <MJRefresh.h>

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"changeBar" style:UIBarButtonItemStylePlain target:self action:@selector(changeBar)];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        [arr addObject:@(i).stringValue];
    }
    self.datas = arr;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.tableView.tableFooterView = [UIView new];
    [tableView addRefreshWithTarget:self headerSelector:@selector(loadDatas) footerSelect:@selector(loadDatas)];
    
    // 无数据
    NSString *emptyText = @"没数据,刷新下";
    // 无数据
    NSMutableAttributedString *emptyAttrText = [[NSMutableAttributedString alloc] initWithString:@"亲,还是没有数据哦(づ￣3￣)づ╭❤～"];
    [emptyAttrText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, emptyAttrText.length)];
    [emptyAttrText addAttribute:NSForegroundColorAttributeName value:UIColor.orangeColor range:NSMakeRange(0, 9)];
    
    // 无网络
    NSString *networkErrorText = @"没网了,重新刷新";
    // 无网络
    NSMutableAttributedString *networkErrorAttrText = [[NSMutableAttributedString alloc] initWithString:@"亲,现在没有网了哦(づ￣3￣)づ╭❤～"];
    [networkErrorAttrText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, networkErrorAttrText.length)];
    [networkErrorAttrText addAttribute:NSForegroundColorAttributeName value:UIColor.orangeColor range:NSMakeRange(0, 9)];
    
    [tableView setupEmptyDataWithEmptyImage:nil emptyText:emptyText emptyAttrText:emptyAttrText networkErrorImage:nil networkErrorText:networkErrorText networkErrorAttrText:networkErrorAttrText offset:0 tapBlock:^{
        NSLog(@"%s",__FUNCTION__);
        [self loadDatas];
    }];
    
    
}

- (void)changeBar{
    self.hbd_barAlpha = 0;
    [self hbd_setNeedsUpdateNavigationBarAlpha];
}

- (void)loadDatas{
    self.tableView.tag++;
    NSLog(@"%s",__FUNCTION__);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.tag++;
        int value = self.tableView.tag % 3;
        if (value == 0) {
            // 正常状态
            self.datas = [NSMutableArray array];
            for (int i = 0; i < 10; i ++) {
                [self.datas addObject:@(i).stringValue];
            }
        }else if (value == 1) {
            // 无数据
            self.datas = nil;
            self.tableView.emptyDataType = EmptyDataTypeNormal;
        }else if (value == 2) {
            // 无网络
            self.datas = nil;
            self.tableView.emptyDataType = EmptyDataTypeNetworkError;
        }
        
        self.tableView.isLoading = NO;
        [self.tableView headerStartRefresh];
        [self.tableView reloadData];
        [self.tableView reloadEmptyDataSet];
    });
}

//- (void)loadDatas{
//    NSLog(@"%s",__FUNCTION__);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.tableView.emptyDataType = EmptyDataTypeNormal;
//
//        self.tableView.tag++;
//        int value = self.tableView.tag % 3;
//        if (value == 0) {
//            self.datas = [NSMutableArray array];
//            for (int i = 0; i < 10; i ++) {
//                [self.datas addObject:@(i).stringValue];
//            }
//        }else if (value == 1) {
//            [self.datas removeAllObjects];
//        }else if (value == 2) {
//
//            self.tableView.emptyDataType = EmptyDataTypeNetworkError;
//        }
//
//        self.tableView.isLoading = NO;
//        [self.tableView stopRefresh];
//        [self.tableView reloadData];
//    });
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

@end
