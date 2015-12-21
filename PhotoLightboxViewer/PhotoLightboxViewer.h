//
//  PhotoLightboxViewer.h
//
//  Created v1.0 by markelsoft on 4/14/15.
//  Copyright MarkelSoft, Inc. 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PLVImageViewController.h"
#import "QBImagePickerController.h"

@interface PhotoLightboxViewer : NSObject <QBImagePickerControllerDelegate> {
    
    UIViewController * _parent;
}

@property (nonatomic, strong) UIViewController * _parent;
@property (nonatomic, strong) PhotoLightboxViewer * plv;

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

@end
