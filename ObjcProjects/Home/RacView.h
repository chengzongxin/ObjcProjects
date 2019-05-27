//
//  RacView.h
//  ObjcProjects
//
//  Created by Joe on 2019/5/27.
//  Copyright © 2019 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RacView : UIView

@property (strong, nonatomic) RACSubject *buttonSubject;

@property (strong, nonatomic) RACSubject *textSubject;

@end

NS_ASSUME_NONNULL_END
