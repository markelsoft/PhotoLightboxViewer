//
//  AddressFindAppDelegate.h
//  UIVideoViewDemo
//
//  Created by markelsoft on 7/22/11.
//  Copyright 2011 MarkelSoft, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AddressFindAppDelegate : NSObject <UIApplicationDelegate> {
	MainViewController * mainViewController;
	UIScrollView * scrollView;
	UIWindow * window;
	UINavigationController *navigationController;
}

@property (nonatomic, strong) UIWindow * window;
@property (nonatomic, strong) MainViewController * mainViewController;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;    

@end

