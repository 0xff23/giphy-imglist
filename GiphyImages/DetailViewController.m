//
//  DetailViewController.m
//  GiphyImages
//
//  Created by Kirill G on 3/22/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
#import "AnimatedGIFImageSerialization.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation DetailViewController

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center = self.imageView.center;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.imageView addSubview:_activityIndicator];
        
    }
    return _activityIndicator;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (void)configureView
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];

    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:self.imageURL
                      placeholderImage:nil
                               options:SDWebImageProgressiveDownload
                              progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      float progress = 0;
                                      if (expectedSize != 0) {
                                          progress = (float)receivedSize / (float)expectedSize;
                                      }
                                      weakSelf.progressView.hidden = NO;
                                      [weakSelf.progressView setProgress:progress animated:YES];
                                  });
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 weakSelf.progressView.hidden = YES;
                                 [weakSelf.activityIndicator stopAnimating];
                                 weakSelf.activityIndicator.hidden = YES;

                             }];
}

- (void)viewDidLoad
{
    //MARK: Navigation bar title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-60, self.navigationController.navigationBar.frame.size.height)];
    titleLabel.text = self.imageTitle;
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    
    [super viewDidLoad];
    [self configureView];
    self.navigationItem.titleView = titleLabel;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.progressView.frame = CGRectMake(0, self.topLayoutGuide.length, CGRectGetWidth(self.view.bounds), 2.0);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
