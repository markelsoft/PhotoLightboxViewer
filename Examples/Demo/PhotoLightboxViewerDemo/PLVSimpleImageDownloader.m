//
//  PLVSimpleImageDownloader.m
//
//  Created by markelsoft on 4/14/15.
//  Copyright MarkelSoft, Inc. 2015. All rights reserved.
//

#import "PLVSimpleImageDownloader.h"

#import "PLVAnimatedGIFUtility.h"

@implementation PLVSimpleImageDownloader

+ (NSURLSessionDataTask *)downloadImageForURL:(NSURL *)imageURL canonicalURL:(NSURL *)canonicalURL completion:(void (^)(UIImage *))completion {
    
    NSURLSessionDataTask *dataTask = nil;
    
    if (imageURL.absoluteString.length) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        
        if (request == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil);
                }
            });
        }
        else {
            
            NSURLSession *sesh = [NSURLSession sharedSession];
            
            dataTask = [sesh dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    UIImage *image = [self imageFromData:data forURL:imageURL canonicalURL:canonicalURL];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(image);
                        }
                    });
                    
                });
                
            }];
            
            [dataTask resume];
        }
    }
    
    return dataTask;
}

+ (UIImage *)imageFromData:(NSData *)data forURL:(NSURL *)imageURL canonicalURL:(NSURL *)canonicalURL {
    UIImage *image = nil;
    
    if (data) {
        NSString *referenceURL = (canonicalURL.absoluteString.length) ? canonicalURL.absoluteString : imageURL.absoluteString;
        if ([PLVAnimatedGIFUtility imageURLIsAGIF:referenceURL]) {
            image = [PLVAnimatedGIFUtility animatedImageWithAnimatedGIFData:data];
        }
        if (image == nil) {
            image = [[UIImage alloc] initWithData:data];
        }
    }
    
    return image;
}

@end






