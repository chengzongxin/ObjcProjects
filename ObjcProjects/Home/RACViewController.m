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
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UILabel *label;

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
//    [self.textFiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"text field events %@",x);
//    }];
    
    self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"button click %@",input);
        return [RACSignal empty];
    }];
    
    RACSignal *textSingnal = self.textFiled.rac_textSignal;
    RACSignal *button1Singnal = [[self.button1 rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id _Nullable(__kindof UIControl * _Nullable value) {
        NSLog(@"button1 = %@",value);
        return [NSDate date];
    }];
    RACSignal *button2Singnal = [[self.button2 rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id _Nullable(__kindof UIControl * _Nullable value) {
        NSLog(@"button2 = %@",value);
        return [NSDate date];
    }];
    
//    RACSignal *merged = [RACSignal merge:@[textSingnal,button1Singnal,button2Singnal]];
//    [merged subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    RACSignal *combined = [RACSignal combineLatest:@[textSingnal,button1Singnal,button2Singnal]];
    
//    [combined subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    RAC(self.label,text) = [combined reduceEach:^(id x,id y,id z){
        return [NSString stringWithFormat:@"%@\n%@\n%@",x,y,z];
    }];
}



- (void)subviewEvent{
    RacView *view = [[RacView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view.backgroundColor = UIColor.grayColor;
    [self.view addSubview:view];
    
//    view.buttonSubject = [[RACSubject alloc] init];
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
