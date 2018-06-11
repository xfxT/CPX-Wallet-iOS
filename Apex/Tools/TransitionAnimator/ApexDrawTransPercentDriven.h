//
//  ApexDrawTransPercentDriven.h
//  Apex
//
//  Created by chinapex on 2018/6/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexDrawTransPercentDriven : UIPercentDrivenInteractiveTransition
singleH(Driven);
- (void)startPushWithDuration:(NSTimeInterval)duration;
- (void)startPopWithDuration:(NSTimeInterval)duration;

//toVC pop回来时的percent控制方法
- (void)setPercentDrivenForFakeView:(UIView*)view ToViewController:(UIViewController*)viewController drawTransFromDelta:(CGFloat)delta;
/* fromVC push过去时的percent控制方法 需要在viewcontroller里调用*/
- (void)setPercentDrivenForFromViewController:(UIViewController*)fromVC edgePan:(void (^)(UIScreenEdgePanGestureRecognizer *edgePan))panGesture;

@end
