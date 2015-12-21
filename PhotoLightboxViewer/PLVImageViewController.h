//
//  PLVImageViewController.h
//
//  Created by markelsoft on 4/14/15.
//  Copyright MarkelSoft, Inc. 2015. All rights reserved.
//

#import <UIKit/UIKit.h> 

#import "PLVImageInfo.h"

///--------------------------------------------------------------------------------------------------------------------
/// Definitions
///--------------------------------------------------------------------------------------------------------------------

@protocol PLVImageViewControllerDismissalDelegate;
@protocol PLVImageViewControllerOptionsDelegate;
@protocol PLVImageViewControllerInteractionsDelegate;
@protocol PLVImageViewControllerAccessibilityDelegate;
@protocol PLVImageViewControllerAnimationDelegate;

typedef NS_ENUM(NSInteger, PLVImageViewControllerMode) {
    PLVImageViewControllerMode_Image,
    PLVImageViewControllerMode_AltText,
};

typedef NS_ENUM(NSInteger, PLVImageViewControllerTransition) {
    PLVImageViewControllerTransition_FromOriginalPosition,
    PLVImageViewControllerTransition_FromOffscreen,
};

typedef NS_OPTIONS(NSInteger, PLVImageViewControllerBackgroundOptions) {
    PLVImageViewControllerBackgroundOption_None = 0,
    PLVImageViewControllerBackgroundOption_Scaled = 1 << 0,
    PLVImageViewControllerBackgroundOption_Blurred = 1 << 1,
};

extern CGFloat const PLVImageViewController_DefaultAlphaForBackgroundDimmingOverlay;
extern CGFloat const PLVImageViewController_DefaultBackgroundBlurRadius;

///--------------------------------------------------------------------------------------------------------------------
/// PLVImageViewController
///--------------------------------------------------------------------------------------------------------------------

@interface PLVImageViewController : UIViewController

@property (strong, nonatomic, readonly) PLVImageInfo *imageInfo;

@property (strong, nonatomic, readonly) UIImage *image;

@property (assign, nonatomic, readonly) PLVImageViewControllerMode mode;

@property (assign, nonatomic, readonly) PLVImageViewControllerBackgroundOptions backgroundOptions;

@property (strong, nonatomic, readwrite) id <PLVImageViewControllerDismissalDelegate> dismissalDelegate;

@property (strong, nonatomic, readwrite) id <PLVImageViewControllerOptionsDelegate> optionsDelegate;

@property (strong, nonatomic, readwrite) id <PLVImageViewControllerInteractionsDelegate> interactionsDelegate;

@property (strong, nonatomic, readwrite) id <PLVImageViewControllerAccessibilityDelegate> accessibilityDelegate;

@property (strong, nonatomic, readwrite) id <PLVImageViewControllerAnimationDelegate> animationDelegate;

/**
 Designated initializer.
 
 @param imageInfo The source info for image and transition metadata. Required.
 
 @param mode The mode to be used. (PLVImageViewController has an alternate alt text mode). Required.
 
 @param backgroundStyle Currently, either scaled-and-dimmed, or scaled-dimmed-and-blurred. 
 The latter is like Tweetbot 3.0's background style.
 */
- (instancetype)initWithImageInfo:(PLVImageInfo *)imageInfo
                             mode:(PLVImageViewControllerMode)mode
                  backgroundStyle:(PLVImageViewControllerBackgroundOptions)backgroundOptions;

/**
 PLVImageViewController is presented from viewController as a UIKit modal view controller.
 
 It's first presented as a full-screen modal *without* animation. At this stage the view controller
 is merely displaying a snapshot of viewController's topmost parentViewController's view.
 
 Next, there is an animated transition to a full-screen image viewer.
 */
- (void)showFromViewController:(UIViewController *)viewController
                    transition:(PLVImageViewControllerTransition)transition;

/**
 Dismisses the image viewer. Must not be called while previous presentation or dismissal is still in flight.
 */
- (void)dismiss:(BOOL)animated;

@end

///--------------------------------------------------------------------------------------------------------------------
/// Dismissal Delegate
///--------------------------------------------------------------------------------------------------------------------

@protocol PLVImageViewControllerDismissalDelegate <NSObject>

/**
 Called after the image viewer has finished dismissing.
 */
- (void)imageViewerDidDismiss:(PLVImageViewController *)imageViewer;

@end

///--------------------------------------------------------------------------------------------------------------------
/// Options Delegate
///--------------------------------------------------------------------------------------------------------------------

@protocol PLVImageViewControllerOptionsDelegate <NSObject>
@optional

/**
 Return YES if you want the image thumbnail to fade to/from zero during presentation
 and dismissal animations.
 
 This may be helpful if the reference image in your presenting view controller has been
 dimmed, such as for a dark mode. PLVImageViewController otherwise presents the animated 
 image view at full opacity, which can look jarring.
 */
- (BOOL)imageViewerShouldFadeThumbnailsDuringPresentationAndDismissal:(PLVImageViewController *)imageViewer;

/**
 The font used in the alt text mode's text view.
 
 This method is only used with `PLVImageViewControllerMode_AltText`.
 */
- (UIFont *)fontForAltTextInImageViewer:(PLVImageViewController *)imageViewer;

/**
 The tint color applied to tappable text and selection controls.
 
 This method is only used with `PLVImageViewControllerMode_AltText`.
 */
- (UIColor *)accentColorForAltTextInImageViewer:(PLVImageViewController *)imageView;

/**
 The background color of the image view itself, not to be confused with the background
 color for the view controller's view. 
 
 You may wish to override this method if displaying an image with dark content on an 
 otherwise clear background color (such as images from the XKCD What If? site).
 
 The default color is `[UIColor clearColor]`.
 */
- (UIColor *)backgroundColorImageViewInImageViewer:(PLVImageViewController *)imageViewer;

/**
 Defaults to `PLVImageViewController_DefaultAlphaForBackgroundDimmingOverlay`.
 */
- (CGFloat)alphaForBackgroundDimmingOverlayInImageViewer:(PLVImageViewController *)imageViewer;

/**
 Used with a PLVImageViewControllerBackgroundStyle_ScaledDimmedBlurred background style.
 
 Defaults to `PLVImageViewController_DefaultBackgroundBlurRadius`. The larger the radius,
 the more profound the blur effect. Larger radii may lead to decreased performance on
 older devices. To offset this, PLVImageViewController applies the blur effect to a
 scaled-down snapshot of the background view.
 */
- (CGFloat)backgroundBlurRadiusForImageViewer:(PLVImageViewController *)imageViewer;

@end

///--------------------------------------------------------------------------------------------------------------------
/// Interactions Delegate
///--------------------------------------------------------------------------------------------------------------------

@protocol PLVImageViewControllerInteractionsDelegate <NSObject>
@optional

/**
 Called when the image viewer detects a long press.
 */
- (void)imageViewerDidLongPress:(PLVImageViewController *)imageViewer atRect:(CGRect)rect;

/**
 Called when the image viewer is deciding whether to respond to user interactions.
 
 You may need to return NO if you are presenting custom, temporary UI on top of the image viewer. 
 This method is called more than once. Returning NO does not "lock" the image viewer.
 */
- (BOOL)imageViewerShouldTemporarilyIgnoreTouches:(PLVImageViewController *)imageViewer;

/**
 Called when the image viewer is deciding whether to display the Menu Controller, to allow the user to copy the image to the general pasteboard.
 */
- (BOOL)imageViewerAllowCopyToPasteboard:(PLVImageViewController *)imageViewer;

@end

///--------------------------------------------------------------------------------------------------------------------
/// Accessibility Delegate
///--------------------------------------------------------------------------------------------------------------------


@protocol PLVImageViewControllerAccessibilityDelegate <NSObject>
@optional

- (NSString *)accessibilityLabelForImageViewer:(PLVImageViewController *)imageViewer;

- (NSString *)accessibilityHintZoomedInForImageViewer:(PLVImageViewController *)imageViewer;

- (NSString *)accessibilityHintZoomedOutForImageViewer:(PLVImageViewController *)imageViewer;

@end

///---------------------------------------------------------------------------------------------------
/// Animation Delegate
///---------------------------------------------------------------------------------------------------

@protocol PLVImageViewControllerAnimationDelegate <NSObject>
@optional

- (void)imageViewerWillBeginPresentation:(PLVImageViewController *)imageViewer withContainerView:(UIView *)containerView;

- (void)imageViewerWillAnimatePresentation:(PLVImageViewController *)imageViewer withContainerView:(UIView *)containerView duration:(CGFloat)duration;

- (void)imageViewer:(PLVImageViewController *)imageViewer willAdjustInterfaceForZoomScale:(CGFloat)zoomScale withContainerView:(UIView *)containerView duration:(CGFloat)duration;

- (void)imageViewerWillBeginDismissal:(PLVImageViewController *)imageViewer withContainerView:(UIView *)containerView;

- (void)imageViewerWillAnimateDismissal:(PLVImageViewController *)imageViewer withContainerView:(UIView *)containerView duration:(CGFloat)duration;

@end








