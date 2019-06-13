//
//  DragView.m
//  ObjcProjects
//
//  Created by Joe on 2019/6/13.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "DragView.h"

@implementation DragView
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@,%@",touches,event);
    
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    CGPoint preP = [touch previousLocationInView:self];
    
    CGFloat offsetX = curP.x - preP.x;
    CGFloat offsetY = curP.y - preP.y;
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    } completion:nil];
}
@end
