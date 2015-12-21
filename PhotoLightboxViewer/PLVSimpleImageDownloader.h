//
//  PLVSimpleImageDownloader.h
//  
//  Created by markelsoft on 4/14/15.
//  Copyright MarkelSoft, Inc. 2015. All rights reserved.
//

#import <Foundation/foundation.h>

@interface PLVSimpleImageDownloader : NSObject

+ (NSURLSessionDataTask *)downloadImageForURL:(NSURL *)imageURL
                                 canonicalURL:(NSURL *)canonicalURL
                                   completion:(void(^)(UIImage *image))completion;

@end
