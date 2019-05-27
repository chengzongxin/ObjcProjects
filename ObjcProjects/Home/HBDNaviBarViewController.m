//
//  HBDNaviBarViewController.m
//  ObjcProjects
//
//  Created by Joe on 2019/5/27.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "HBDNaviBarViewController.h"
#import "HBDNavigationBar.h"
#import "UIViewController+HBD.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface HBDNaviBarViewController ()

@property (weak, nonatomic) IBOutlet UILabel *alphaLabel;
@end

@implementation HBDNaviBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.blueColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = UIColor.grayColor;
    [self.view addSubview:view];
    
    UIVisualEffectView *fakeView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    //    recursiveDescription
    NSLog(@"%@",fakeView.subviews);
    self.hbd_barTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

- (void)next{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)buttonClick:(id)sender {
}


- (void)log{
    
    NSLog(@"%s",__FUNCTION__);
    
    // Convert from this:
    //    NSLog(@"Broken sprocket detected!");
    //    NSLog(@"User selected file:%@ withSize:%u", @"filePath", 12);
    
    // To this:
    //    DDLogError(@"123231");
    //    DDLogVerbose(@"213");
    //
    //        DDLogError(@"Broken sprocket detected!");
    //        DDLogVerbose(@"User selected file:%@ withSize:%u", @"filePath", 123);
    DDLogWarn(@"DDLogWarn");
    DDLogVerbose(@"DDLogVerbose");
    DDLogInfo(@"123");
    DDLogError(@"123123");
    
    
    //#define DDLogVError(frmt, avalist)   LOGV_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, avalist)
    //#define DDLogVWarn(frmt, avalist)    LOGV_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, avalist)
    //#define DDLogVInfo(frmt, avalist)    LOGV_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, avalist)
    //#define DDLogVDebug(frmt, avalist)   LOGV_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, avalist)
    //#define DDLogVVerbose(frmt, avalist) LOGV_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, avalist)
}

/**
 导航栏透明度
 */
- (IBAction)sliderValueChange:(UISlider *)slider {
    self.alphaLabel.text = [NSString stringWithFormat:@"Alpha : %g",slider.value];
    self.hbd_barAlpha = slider.value;
    [self hbd_setNeedsUpdateNavigationBarAlpha];
}


/**
 导航栏背景色
 */
- (IBAction)whiteColor:(id)sender {
    self.hbd_barTintColor = UIColor.whiteColor;
    [self hbd_setNeedsUpdateNavigationBarColorOrImage];
}
- (IBAction)randomColor:(id)sender {
    self.hbd_barTintColor = [[self class] randomColor];
    [self hbd_setNeedsUpdateNavigationBarColorOrImage];
}


/**
 隐藏导航栏下划线
 */
- (IBAction)shadownSwichChanged:(UISwitch *)switchButton {
    self.hbd_barShadowHidden = switchButton.isOn;
    [self hbd_setNeedsUpdateNavigationBarShadowAlpha];
}


/**
 隐藏导航栏
 */
- (IBAction)navigationBarChanged:(UISwitch *)switchButton {
    //    self.hbd_barHidden = switchButton.isOn;
    //    [self hbd_setNeedsUpdateNavigationBar];
    self.navigationController.navigationBar.hidden = switchButton.isOn;
    [self log];
}

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
