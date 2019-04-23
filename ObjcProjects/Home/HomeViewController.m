//
//  HomeViewController.m
//  NavigationBarDemo
//
//  Created by Joe on 2019/4/23.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "HomeViewController.h"
#import "HBDNavigationBar.h"
#import "UIViewController+HBD.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.blueColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = UIColor.grayColor;
    [self.view addSubview:view];
    
    self.hbd_barTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

- (void)next{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sliderValueChange:(UISlider *)slider {
    self.hbd_barAlpha = slider.value;
    [self hbd_setNeedsUpdateNavigationBarAlpha];
}
- (IBAction)whiteColor:(id)sender {
    self.hbd_barTintColor = UIColor.whiteColor;
    [self hbd_setNeedsUpdateNavigationBar];
}
- (IBAction)randomColor:(id)sender {
    self.hbd_barTintColor = [[self class] randomColor];
    [self hbd_setNeedsUpdateNavigationBar];
}

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
