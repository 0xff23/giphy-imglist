//
//  GifCell.h
//  GiphyImages
//
//  Created by Kirill G on 3/22/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GifCell : UITableViewCell

@property (strong, nonatomic) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *raitingLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
