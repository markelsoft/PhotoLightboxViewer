//
//  UIApplication+PLVImageViewController.m
//
//  Created by markelsoft on 4/14/15.
//  Copyright MarkelSoft, Inc. 2015. All rights reserved.
//

#import "UIApplication+PLVImageViewController.h"

@implementation UIApplication (PLVImageViewController)

- (BOOL)PLV_usesViewControllerBasedStatusBarAppearance {
    
    static dispatch_once_t once;
    static BOOL viewControllerBased;
    
    dispatch_once(&once, ^ {
        NSString *key = @"UIViewControllerBasedStatusBarAppearance";
        id object = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
        if (!object) {
            viewControllerBased = YES;
        } else {
            viewControllerBased = [object boolValue];
        }
    });
    
    return viewControllerBased;
}

@end
