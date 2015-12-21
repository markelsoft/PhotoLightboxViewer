//
//  QBAssetsCollectionViewCell.h
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface QBAssetsCollectionViewCell : UICollectionViewCell {
    
    UIButton *videoButton;
    UIButton *photoButton;
    UIButton *newButton;
}

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) BOOL showsOverlayViewWhenSelected;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) BOOL isNew;

- (void)clearButtons;
- (void)markVideo:(BOOL)isVideo;
- (void)markNew:(BOOL)isNew;

@end
