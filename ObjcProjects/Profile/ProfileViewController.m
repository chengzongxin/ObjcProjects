//
//  ProfileViewController.m
//  NavigationBarDemo
//
//  Created by Joe on 2019/4/23.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "ProfileViewController.h"
#import "MQTTManager.h"
#import <MJExtension.h>

@interface ProfileViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datas = [NSMutableArray array];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    NSString *topic1 = @"/cheng";
    NSString *topic2 = @"/zong";
    NSString *topic3 = @"/xin";
    
    [[MQTTManager sharedInstance] subscribeTopics:@[topic1,topic2,topic3] subscribeHandler:^(NSString *topic, NSError *error, NSArray<NSNumber *> *gQoss) {
        NSLog(@"\n\n[topic]:%@\n[error]:%@",topic,error);
    } dataHandler:^(MQTTBaseModel *data, NSString *topic) {
        NSLog(@"\n\n[topic]:%@\n[data]:%@",topic,data.mj_JSONString);
        [self.datas addObject:data.mj_JSONString];
        [self.tableView reloadData];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

@end
