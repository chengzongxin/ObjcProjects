//
//  MainTabBarController.m
//  Matafy
//
//  Created by Jason on 2018/10/12.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

// 一次性设置
//+ (void)initialize
//{
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//    attrs[NSForegroundColorAttributeName] = HEXCOLOR(0x232629);
//
//    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//    selectedAttrs[NSForegroundColorAttributeName] = HEXCOLOR(0x00C3CE);
//
//    UITabBarItem *item = [UITabBarItem appearance];
//    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
//    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置所有的子视图
    [self setupAllChildVC];
}

// 设置所有的子视图
- (void)setupAllChildVC {
    // 首页
    UIViewController *home = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController];
    [self setupChildVC:home title:@"Home" image:nil];
    // 社区
    UIViewController *Community = [[UIStoryboard storyboardWithName:@"Community" bundle:nil] instantiateInitialViewController];
    [self setupChildVC:Community title:@"Community" image:nil];
    // 消息
    UIViewController *Message = [[UIStoryboard storyboardWithName:@"Message" bundle:nil] instantiateInitialViewController];
    [self setupChildVC:Message title:@"Message" image:nil];
    // 我的
    UIViewController *Profile = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateInitialViewController];
    [self setupChildVC:Profile title:@"Profile" image:nil];
}

// 初始化子控制器
- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image{
    // 设置文字
    vc.title = title;
    // 设置图片
    
    vc.tabBarItem.image = [[UIImage new] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageSTR] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addChildViewController:vc];
}


@end
