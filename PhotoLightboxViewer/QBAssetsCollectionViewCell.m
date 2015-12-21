//
//  QBAssetsCollectionViewCell.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionViewCell.h"

// Views
#import "QBAssetsCollectionOverlayView.h"

@interface QBAssetsCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) QBAssetsCollectionOverlayView *overlayView;

@end

@implementation QBAssetsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.showsOverlayViewWhenSelected = YES;
        self.isVideo = NO;
        
        // Create a image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    
    return self;
}

- (void)clearButtons
{
    if (videoButton != nil) {
        [videoButton removeFromSuperview];
        videoButton = nil;
    }

    if (newButton != nil) {
        [newButton removeFromSuperview];
        newButton = nil;
    }

}

- (void)markVideo:(BOOL)isVideo
{
    self.isVideo = isVideo;

    if (self.isVideo) {
        //NSLog(@"asset is a video - %@", _asset);
        
        videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //videoButton.frame = CGRectMake(24, -2, 24, 24);
        videoButton.frame = CGRectMake(2, self.frame.size.height-18, 18, 14);
        UIImageView * iconVideo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video.png"]];
        [videoButton setImage:iconVideo.image forState:UIControlStateNormal];
        [self addSubview:videoButton];

    } else {
        //NSLog(@"asset is a photo - %@", _asset);
        
        if (videoButton != nil) {
            [videoButton removeFromSuperview];
            videoButton = nil;
        }
    }
}

- (void)markNew:(BOOL)isNew
{
    self.isNew = isNew;
    
    if (self.isNew) {
        
        if (self.isVideo) {
            //NSLog(@"asset is a new video - %@", _asset);
        } else {
            //NSLog(@"asset is a new photo - %@", _asset);
        }
        
        newButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //newButton.frame = CGRectMake(24, -2, 24, 24);
        newButton.frame = CGRectMake(self.frame.size.width-22, self.frame.size.height-22, 24, 24);
        UIImageView * iconNew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new-asset.png"]];
        [newButton setImage:iconNew.image forState:UIControlStateNormal];
        [self addSubview:newButton];
        
    } else {
        
        if (newButton != nil) {
            [newButton removeFromSuperview];
            newButton = nil;
        }
    }
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    if (selected && self.showsOverlayViewWhenSelected) {
        [self hideOverlayView];
        [self showOverlayView];
    } else {
        [self hideOverlayView];
    }
}

- (void)showOverlayView
{
    QBAssetsCollectionOverlayView *overlayView = [[QBAssetsCollectionOverlayView alloc] initWithFrame:self.contentView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:overlayView];
    self.overlayView = overlayView;
}

- (void)hideOverlayView
{
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
}


#pragma mark - Accessors

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    
    // Update view
    self.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}

@end
