//
//  GKPushTransitionAnimation.m
//  GKNavigationBarViewControllerDemo
//
//  Created by QuintGao on 2017/7/10.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKPushTransitionAnimation.h"
#import "GKCommon.h"
#import "UIView+GKCategory.h"

@implementation GKPushTransitionAnimation

- (void)animateTransition {
    UIImage *fromImage = [self.fromViewController.view.window gk_captureCurrentView];
    self.fromImgView.image = fromImage;
    self.fromImgView.frame = CGRectMake(0, 0, GK_SCREEN_WIDTH, GK_SCREEN_HEIGHT);
    [self.fromViewController.view addSubview:self.fromImgView];
    
    [self.containerView addSubview:self.toViewController.view];
    
    // tabbar处理
    BOOL isHideTabBar = self.toViewController.hidesBottomBarWhenPushed;
    
    if (isHideTabBar) {
        [self getCurrentTabBar].hidden = YES;
    }
    
    // 设置转场前的frame
    self.toViewController.view.frame = CGRectMake(GK_SCREEN_WIDTH, 0, GK_SCREEN_WIDTH, GK_SCREEN_HEIGHT);
    
    if (self.scale) {
        // 初始化阴影并添加
        self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GK_SCREEN_WIDTH, GK_SCREEN_HEIGHT)];
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.fromViewController.view addSubview:self.shadowView];
    }
    
    self.toViewController.view.layer.shadowColor   = [[UIColor blackColor] CGColor];
    self.toViewController.view.layer.shadowOpacity = 0.6;
    self.toViewController.view.layer.shadowRadius  = 8;
    
    // 执行动画
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] animations:^{
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        if (self.scale) {
            
            if (GKDeviceVersion >= 11.0) {
                CGRect frame = self.fromViewController.view.frame;
                frame.origin.x     = 5;
                frame.origin.y     = 5;
                frame.size.height -= 10;
                
                self.fromViewController.view.frame = frame;
            }else {
                self.fromViewController.view.transform = CGAffineTransformMakeScale(0.95, 0.97);
            }
            
        }else {
            self.fromViewController.view.frame = CGRectMake(- (0.3 * GK_SCREEN_WIDTH), 0, GK_SCREEN_WIDTH, GK_SCREEN_HEIGHT);
        }
        
        self.toViewController.view.frame = CGRectMake(0, 0, GK_SCREEN_WIDTH, GK_SCREEN_HEIGHT);
    }completion:^(BOOL finished) {
        [self completeTransition];
        [self.shadowView removeFromSuperview];
        [self.fromImgView removeFromSuperview];
        
        if (isHideTabBar) {
            [self getCurrentTabBar].hidden = NO;
        }
    }];
}

@end
