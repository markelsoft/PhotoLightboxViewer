//
//  PhotoLightboxViewer.m
//
//  Created v1.0 by markelsoft on 4/14/15.
//  Copyright MarkelSoft, Inc. 2015. All rights reserved.
//

#import "PhotoLightboxViewer.h"

@implementation PhotoLightboxViewer

@synthesize _parent;

PhotoLightboxViewer * plv = nil;

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
+ (void)showPhotoUsingUrl:(NSURL *)imageUrl fromParent:(UIViewController *)parent blurBackground:(BOOL)blurBackground  useDownloader:(BOOL)useDownloader {
    
    PLVImageInfo * imageInfo = [[PLVImageInfo alloc] init];
    
    if (useDownloader) {
        //NSLog(@"Using downloader to load image...");
        imageInfo.image = nil;
        imageInfo.imageURL = imageUrl;
    } else {
        //NSLog(@"Not using downloader so loading image...");
        NSData * imagePhotoData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage * iconDetails = [[UIImage alloc] initWithData:imagePhotoData];
        imageInfo.image = iconDetails;
    }
    
    PLVImageViewController * imageViewer = nil;
    
    if (blurBackground) {
        imageViewer = [[PLVImageViewController alloc] initWithImageInfo:imageInfo
                                                                        mode:PLVImageViewControllerMode_Image
                                                                        backgroundStyle:PLVImageViewControllerBackgroundOption_Blurred];

    } else {
        imageViewer = [[PLVImageViewController alloc] initWithImageInfo:imageInfo
                                                                        mode:PLVImageViewControllerMode_Image
                                                                        backgroundStyle:PLVImageViewControllerBackgroundOption_Scaled];
    }
    
    
    // Present the view controller.
    [imageViewer showFromViewController:parent transition:PLVImageViewControllerTransition_FromOriginalPosition];
}

// Show photo using image
//
// UIImage * image - photo image
// UIViewController * parent - parent view controller to show from
// BOOL blurBackground - if TRUE blur the background
//                       if FALSE then do not blur the background
+ (void)showPhotoUsingImage:(UIImage *)image fromParent:(UIViewController *)parent blurBackground:(BOOL)blurBackground  {
    
    PLVImageInfo * imageInfo = [[PLVImageInfo alloc] init];
    imageInfo.image = image;
    
    // Setup view controller
    PLVImageViewController * imageViewer = nil;
    
    if (blurBackground) {
        imageViewer = [[PLVImageViewController alloc] initWithImageInfo:imageInfo
                                                                   mode:PLVImageViewControllerMode_Image
                                                        backgroundStyle:PLVImageViewControllerBackgroundOption_Blurred];
        
    } else {
        imageViewer = [[PLVImageViewController alloc] initWithImageInfo:imageInfo
                                                                        mode:PLVImageViewControllerMode_Image
                                                                        backgroundStyle:PLVImageViewControllerBackgroundOption_Scaled];
    }
    
    // Present the view controller.
    [imageViewer showFromViewController:parent transition:PLVImageViewControllerTransition_FromOriginalPosition];
}

// show photo using image data
//
// NSData * imageData - photo image data
// UIViewController * parent - parent view controller to show from
// BOOL blurBackground - if TRUE blur the background
//                       if FALSE then do not blur the background
+ (void)showPhotoUsingImageData:(NSData *)imageData fromParent:(UIViewController *)parent blurBackground:(BOOL)blurBackground {
    
    PLVImageInfo * imageInfo = [[PLVImageInfo alloc] init];
    UIImage * image = [[UIImage alloc] initWithData:imageData];
    imageInfo.image = image;
    
    // Setup view controller
    PLVImageViewController * imageViewer = nil;
    
    if (blurBackground) {
        imageViewer = [[PLVImageViewController alloc] initWithImageInfo:imageInfo
                                                                   mode:PLVImageViewControllerMode_Image
                                                        backgroundStyle:PLVImageViewControllerBackgroundOption_Blurred];
        
    } else {
        imageViewer = [[PLVImageViewController alloc] initWithImageInfo:imageInfo
                                                                   mode:PLVImageViewControllerMode_Image
                                                        backgroundStyle:PLVImageViewControllerBackgroundOption_Scaled];
    }
    
    // Present the view controller.
    [imageViewer showFromViewController:parent transition:PLVImageViewControllerTransition_FromOriginalPosition];

}

// Select and show a photo
//
// UIViewController * parent - parent view controller to show from
+ (void)selectAndShowPhoto:(UIViewController *)parent {

    plv = [[PhotoLightboxViewer alloc] init];
    [plv selectPhoto:parent];
}

- (void)selectPhoto:(UIViewController *)parent {
    
    _parent = parent;
    
    QBImagePickerController * imagePickerControllerAdvanced = [[QBImagePickerController alloc] init];
    imagePickerControllerAdvanced.delegate = self;
    imagePickerControllerAdvanced.allowsMultipleSelection = NO;
    imagePickerControllerAdvanced.newMediaAge = 3;
    imagePickerControllerAdvanced.filterType = QBImagePickerControllerFilterTypePhotos;
    [imagePickerControllerAdvanced setOnlyPhotosTitle];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerControllerAdvanced];
    //[self presentViewController:imagePickerControllerAdvanced animated:YES completion:nil];
    [_parent presentViewController:navigationController animated:YES completion:nil];
    
}

- (void)dismissImagePickerController {
    
    if (_parent.presentedViewController) {
        [_parent dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [_parent.navigationController popToViewController:_parent animated:YES];
    }
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset {
    
    //NSLog(@"*** imagePickerController:didSelectAsset:");
    //NSLog(@"%@", asset);
    
    [self dismissImagePickerController];

    ALAssetRepresentation * repres = [asset defaultRepresentation];
    CGImageRef ref = [repres fullResolutionImage];
    UIImage * image = [UIImage imageWithCGImage:ref];
   
    [self performSelectorOnMainThread:@selector(nowShowPhoto:) withObject:image waitUntilDone:NO];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    
    //NSLog(@"*** imagePickerController:didSelectAssets:");
    //NSLog(@"%@", assets);
    
    [self dismissImagePickerController];
}

- (void)nowShowPhoto:(UIImage *)image {
    
    [PhotoLightboxViewer showPhotoUsingImage:image fromParent:_parent blurBackground:FALSE];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)_imagePickerController {
    
    //NSLog(@"*** imagePickerControllerDidCancel:");
    
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
    _imagePickerController.delegate = nil;
}

@end
