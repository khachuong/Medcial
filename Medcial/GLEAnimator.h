//
//  GLEAnimator.h
//  DailyDiary
//
//  Created by Khachuong on 6/2/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GLEAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, getter = isPresented) BOOL presenting;

@end
