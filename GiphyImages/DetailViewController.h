//
//  DetailViewController.h
//  GiphyImages
//
//  Created by Kirill G on 3/22/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *imageTitle;

@end
