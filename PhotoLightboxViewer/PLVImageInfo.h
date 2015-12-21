//
//  PLVImageInfo.h
//
//  Created by markelsoft on 4/14/15.
//  Copyright MarkelSoft, Inc. 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLVImageInfo : NSObject

@property (strong, nonatomic) UIImage *image; // If nil, be sure to set either imageURL or canonicalImageURL.
@property (strong, nonatomic) UIImage *placeholderImage; // Use this if all you have is a thumbnail and an imageURL.
@property (copy, nonatomic) NSURL *imageURL;
@property (copy, nonatomic) NSURL *canonicalImageURL; // since `imageURL` might be a filesystem URL from the local cache.
@property (copy, nonatomic) NSString *altText;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) CGRect referenceRect;
@property (strong, nonatomic) UIView *referenceView;
@property (assign, nonatomic) UIViewContentMode referenceContentMode;
@property (assign, nonatomic) CGFloat referenceCornerRadius;
@property (copy, nonatomic) NSMutableDictionary *userInfo;

- (NSString *)displayableTitleAltTextSummary;
- (NSString *)combinedTitleAndAltText;
- (CGPoint)referenceRectCenter;

@end
