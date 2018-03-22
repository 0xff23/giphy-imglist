//
//  GifCell.m
//  GiphyImages
//
//  Created by Kirill G on 3/22/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

#import "GifCell.h"

@implementation GifCell
@synthesize imageView;

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    
    [self downloadImageWithURL:urlString];
}

- (void)downloadImageWithURL:(NSString*)urlString{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                        
                                                        NSData *data = [NSData dataWithContentsOfURL:location];
                                                        UIImage *image = [UIImage imageWithData:data];
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.imageView.image = image;
                                                        });
                                                        
                                                    }];
    [task resume];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
