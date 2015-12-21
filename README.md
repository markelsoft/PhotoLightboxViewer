Purpose
--------------

PhotoLightboxViewer is class to allow iPad, iPhone and iPod Touch apps to easily add a popup “lightbox” view for showing photos.   Photos can be touched and moved, zoomed and closed with any direction swipe.  Includes built-in photo downloader for large photos.

Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 7.0 ARC / Mac OS 10.8 (Xcode 4.3.1, Apple LLVM compiler 3.1)
* Earliest supported deployment target - iOS 6.0 / Mac OS 10.8
* Earliest compatible deployment target - iOS 6.0 / Mac OS 10.8

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


Installation
--------------

To install PhotoLightboxViewer into your app, drag the files in the PhotoLightboxViewer folder into your project.    Make sure that you indicate to copy the files into your project.    Also make sure that the Target Membership is checked for all the .m, .png and .jpg images.


The easiest way to create a PhotoLightboxViewer is to use the showPhotoUsing… APIs. 
 
e.g. [PhotoLightboxViewer showPhotoUsingUrl:];        - shows photo using url.  Has option t use built-in image downloader for large images.
     [PhotoLightboxViewer showPhotoUsingImage:];      - shows photo using image
     [PhotoLightboxViewer showPhotoUsingImageData:];  - shows photo using image data
     [PhotoLightboxViewer selectAndShowPhoto:];       - select and show a photo

Required Frameworks and Libraries
---------------------------------

Must include the following frameworks: AssetsLibrary, CoreFoundation, CoreGraphics, Foundation, ImageIO, MessageUI, QuartzCore, Security, SystemConfiguration and UIKit.


Usage 
-----

// see Demo Example in Examples/Demo folder for full source code

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

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

    // select and show a photo…
    // uncomment to test
    //[PhotoLightboxViewer selectAndShowPhoto:self];
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

// Methods:
// shows photo
//
// touch and hold photo to move
// pinch to zoom
// swipe any direction to close

// Show photo using url
//
// NSURL * imageUrl - url of the photo
// UIViewController * parent - parent view controller to show from
// BOOL blurBackground - if TRUE blur the background
//                       if FALSE then do not blur the background
// BOOL useDownloader - if TRUE use downloader to load images (good for large images
//                      if FALSE then loads images now
+ (void)showPhotoUsingUrl:(NSURL *)imageUrl fromParent:(UIViewController *)parent blurBackground:(BOOL)blurBackground useDownloader:(BOOL)useDownloader;

// Show photo using image
//
// UIImage * image - photo image
// UIViewController * parent - parent view controller to show from
// BOOL blurBackground - if TRUE blur the background
//                       if FALSE then do not blur the background
+ (void)showPhotoUsingImage:(UIImage *)image fromParent:(UIViewController *)parent blurBackground:(BOOL)blurBackground;

// show photo using image data
//
// NSData * imageData - photo image data
// UIViewController * parent - parent view controller to show from
// BOOL blurBackground - if TRUE blur the background
//                       if FALSE then do not blur the background
+ (void)showPhotoUsingImageData:(NSData *)imageData fromParent:(UIViewController *)parent blurBackground:(BOOL)blurBackground;

// select and show photo
//
// UIViewController * parent - parent view controller to show from
+ (void)selectAndShowPhoto:(UIViewController *)parent;

// end of API



Example Project Demo
---------------------

The demo example in the Examples/Demo folder demonstrates how you might implement using PhotoLightboxViewer.   

When pressed, the app displays a list of videos you have uploaded to Facebook.   

The example is for iOS.