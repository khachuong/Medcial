//
//  GLEAnimator.m
//  DailyDiary
//
//  Created by Khachuong on 6/2/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEAnimator.h"

@implementation GLEAnimator
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if(self.presenting){
        
        fromViewController.view.userInteractionEnabled = NO;
        [[transitionContext containerView] addSubview:fromViewController.view];
        [[transitionContext containerView] addSubview:toViewController.view];
        __block CGRect startingFrame = toViewController.view.frame;
        startingFrame.origin.y = CGRectGetHeight(startingFrame);
        toViewController.view.frame = startingFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenHeight = screenRect.size.height;
            
            startingFrame.origin.y -= screenHeight;
            toViewController.view.frame =startingFrame;
        } completion:^(BOOL finished){
            [transitionContext completeTransition:YES];
        }];
        
    }else{
        
        toViewController.view.userInteractionEnabled = YES;
        
        [[transitionContext containerView] addSubview:toViewController.view];
        [[transitionContext containerView] addSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             CGRect frame = fromViewController.view.frame;
                             CGRect screenRect = [[UIScreen mainScreen] bounds];
                             CGFloat screenHeight = screenRect.size.height;

                             frame.origin.y += screenHeight;
                             fromViewController.view.frame = frame;
                         }
                         completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                         }];    }
}
@end
