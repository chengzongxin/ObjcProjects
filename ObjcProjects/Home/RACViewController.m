//
//  RACViewController.m
//  ObjcProjects
//
//  Created by Joe on 2019/5/27.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "RACViewController.h"
#import "RacView.h"

@interface RACViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation RACViewController

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self selfviewEvent];
    
    [self subviewEvent];
}

- (void)selfviewEvent{
    [self.textFiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"text field events %@",x);
    }];
    
    self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"button click %@",input);
        return [RACSignal empty];
    }];
    
//    [self.button setRac_command:[[RACCommand alloc] initWithEnabled:nil signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//
//    }];
}



- (void)subviewEvent{
    RacView *view = [[RacView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view.backgroundColor = UIColor.grayColor;
    [self.view addSubview:view];
    
    view.buttonSubject = [[RACSubject alloc] init];
    @weakify(self);
    [view.buttonSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"racview button click %@",x);
        [self.view endEditing:YES];
    }];
    
    [view.textSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"text event %@",x);
    }];
}

@end
