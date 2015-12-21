//
//  PhotoLightboxViewerDemo.m
//  PhotoLightboxViewerDemo
//
//  Created v1.0 by markelsoft on 04/15/2015.
//
//  Copyright 2015 MarkelSoft, Inc. All rights reserved.
//

#import "MainViewController.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation MainViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

    self.navigationItem.title = @"PhotoLightboxViewer Demo";

	CGRect rect = [[UIScreen mainScreen] bounds];
	screenWidth = rect.size.width;
	screenHeight = rect.size.height; 

    self.view.backgroundColor = [UIColor blackColor];
    
    // show photo using url...
    //     Note: PhotoLightboxView has a built-in downloader so if the photo is large, no problem...
    //
    // loading remote small (800x536) photo, no background blur and do not use built-in image downloader...
    NSURL * photoUrl = [NSURL URLWithString:@"http://www.markelsoft.com/Sunset.png"];
    [PhotoLightboxViewer showPhotoUsingUrl:photoUrl fromParent:self blurBackground:FALSE useDownloader:FALSE];
    
    // loading remote large (3000x1993) photo, no background blur and use built-in image downloader...
    // uncomment to test
    //NSURL * photoUrl = [NSURL URLWithString:@"http://www.markelsoft.com/Sunset-large.jpg"];
    //[PhotoLightboxViewer showPhotoUsingUrl:photoUrl fromParent:self blurBackground:FALSE useDownloader:TRUE];
    
    // loading remote huge (5000x3321) photo, background blur and use built-in image downloader...
    // uncomment to test
    //NSURL * photoUrl = [NSURL URLWithString:@"http://www.markelsoft.com/Sunset-huge.jpg"];
    //[PhotoLightboxViewer showPhotoUsingUrl:photoUrl fromParent:self blurBackground:TRUE useDownloader:TRUE];

    // show photo using local image and backgroun blur...
    // uncomment to test
    //UIImage * photoImage = [UIImage imageNamed:@"Sunset.png"];
    //[PhotoLightboxViewer showPhotoUsingImage:photoImage fromParent:self blurBackground:TRUE];
    
    // show photo using image data and no background blur...
    // uncomment to test
    //NSData * photoData = UIImagePNGRepresentation(photoImage);;
    //[PhotoLightboxViewer showPhotoUsingImageData:photoData fromParent:self blurBackground:FALSE];
    
    // select and show photo...
    // uncomment to test
    //[PhotoLightboxViewer selectAndShowPhoto:self];
    
    // test buttons
    UIButton * showSmallButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showSmallButton.layer.cornerRadius = 8;
    showSmallButton.backgroundColor = [UIColor whiteColor];
    showSmallButton.showsTouchWhenHighlighted = true;
    showSmallButton.frame = CGRectMake(20, 80, 200, 40);
    [showSmallButton setTitle:@"Show Small Photo" forState:UIControlStateNormal];
    [showSmallButton addTarget:self action:@selector(showSmallPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showSmallButton];
    [self.view bringSubviewToFront:showSmallButton];

    
    UIButton * showLargeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showLargeButton.layer.cornerRadius = 8;
    showLargeButton.backgroundColor = [UIColor whiteColor];
    showLargeButton.showsTouchWhenHighlighted = true;
    if ([self isRunningIPad])
        showLargeButton.frame = CGRectMake(240, 80, 200, 40);
    else
        showLargeButton.frame = CGRectMake(20, 140, 200, 40);
    [showLargeButton setTitle:@"Show Large Photo" forState:UIControlStateNormal];
    [showLargeButton addTarget:self action:@selector(showLargePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showLargeButton];
    [self.view bringSubviewToFront:showLargeButton];
    
    UIButton * showHugeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showHugeButton.layer.cornerRadius = 8;
    showHugeButton.backgroundColor = [UIColor whiteColor];
    showHugeButton.showsTouchWhenHighlighted = true;
    if ([self isRunningIPad])
        showHugeButton.frame = CGRectMake(460, 80, 200, 40);
    else
        showHugeButton.frame = CGRectMake(20, 200, 200, 40);
    [showHugeButton setTitle:@"Show Huge Photo" forState:UIControlStateNormal];
    [showHugeButton addTarget:self action:@selector(showHugePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showHugeButton];
    [self.view bringSubviewToFront:showHugeButton];

    UIButton * showSelectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showSelectButton.layer.cornerRadius = 8;
    showSelectButton.backgroundColor = [UIColor whiteColor];
    showSelectButton.showsTouchWhenHighlighted = true;
    if ([self isRunningIPad])
        showSelectButton.frame = CGRectMake(680, 80, 200, 40);
    else
        showSelectButton.frame = CGRectMake(20, 260, 200, 40);
    [showSelectButton setTitle:@"Select Photo" forState:UIControlStateNormal];
    [showSelectButton addTarget:self action:@selector(showSelectPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showSelectButton];
    [self.view bringSubviewToFront:showSelectButton];
    

    UITextView * notesTextView = nil;
    if ([self isRunningIPad])
        notesTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 200, 400, 160)];
    else
        notesTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 360, self.view.frame.size.width, 180)];
    notesTextView.layer.cornerRadius = 8;
    //notesTextView.textAlignment = UIBaselineAdjustmentAlignBaselines;
    notesTextView.font = [UIFont fontWithName:@"Georgia" size:16.0f];
    notesTextView.text = @"Notes:\n\nTouch and hold photo to move around.\nPinch to zoom.\nSwipe in any direction to close.\n\nLarge and huge photos use built-in downloader and show the progress of the photo downloading.";
    notesTextView.backgroundColor = [UIColor yellowColor];
    notesTextView.textColor = [UIColor blackColor];
    notesTextView.editable = false;
    [self.view addSubview:notesTextView];
    
}

// show small photo, no background blur and no image downloader since is a small photo…
- (void)showSmallPhoto {
    
    NSURL * photoUrl = [NSURL URLWithString:@"http://www.markelsoft.com/Sunset.png"];
    [PhotoLightboxViewer showPhotoUsingUrl:photoUrl fromParent:self blurBackground:FALSE useDownloader:FALSE];
}

// show large photo, no background blur and use image downloader since is a large photo…
- (void)showLargePhoto {
    
    NSURL * photoUrl = [NSURL URLWithString:@"http://www.markelsoft.com/Sunset-huge.jpg"];
    [PhotoLightboxViewer showPhotoUsingUrl:photoUrl fromParent:self blurBackground:FALSE useDownloader:TRUE];
}

// show huge photo, background blur and use image downloader since is a huge photo…
- (void)showHugePhoto {
    
    NSURL * photoUrl = [NSURL URLWithString:@"http://www.markelsoft.com/Sunset-huge.jpg"];
    [PhotoLightboxViewer showPhotoUsingUrl:photoUrl fromParent:self blurBackground:TRUE useDownloader:TRUE];
}

// select and show photo...
- (void)showSelectPhoto {
    
    // select and show photo...
    [PhotoLightboxViewer selectAndShowPhoto:self];
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)isRunningIPad {
    BOOL result = FALSE;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]) {
        //NSLog(@"Is running iPad");
        result = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
    } else {
        //NSLog(@"Is running iPad");
    }
    
    return result;
}

@end
