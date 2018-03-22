//
//  TableViewController.m
//  GiphyImages
//
//  Created by Kirill G on 3/22/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

#import "TableViewController.h"
#import "GifCell.h"
#import "DetailViewController.h"
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "UIImageView+WebCache.h"


@interface TableViewController ()
@property (strong, nonatomic) NSMutableArray *imageURLs;
@property (strong, nonatomic) NSMutableArray *raitings;
@property (strong, nonatomic) NSMutableArray *userNames;
@property (strong, nonatomic) NSMutableArray *imageDates;
@property (strong, nonatomic) NSMutableArray *imageTitles;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshImages];
}

- (void) refreshImages {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://api.giphy.com/v1/gifs/trending?&api_key=dwKoxWwPVeAIQI0i9JyY92690OpuAF5O&limit=100"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response != nil) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            // json:data:images:downsized_still:url
            self.imageURLs = [dictionary valueForKeyPath:@"data.images.downsized.url"];
            self.raitings = [dictionary valueForKeyPath:@"data.rating"];
            self.userNames = [dictionary valueForKeyPath:@"data.username"];
            self.imageDates = [dictionary valueForKeyPath:@"data.import_datetime"];
            self.imageTitles = [dictionary valueForKeyPath:@"data.title"];
            
            NSLog(@"%@",self.imageTitles);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } else {
            // Show alert in case of network unavailability
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Internet Connection"
                                                                           message:@"Please make sure Internet is enabled."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }
        
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.imageURLs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"gifCell";
    static UIImage *placeholderImage = nil;
    
    if (!placeholderImage) {
        placeholderImage = [UIImage imageNamed:@"placeholder"];
    }
    
    GifCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GifCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.imageView.sd_imageTransition = SDWebImageTransition.fadeTransition;
    }
    
    cell.raitingLabel.text = self.raitings[indexPath.row];
    cell.userNameLabel.text = self.userNames[indexPath.row];
    cell.dateLabel.text = self.imageDates[indexPath.row];
    
    [cell.imageView sd_setShowActivityIndicatorView:YES];
    [cell.imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[indexPath.row]]
                      placeholderImage:placeholderImage
                               options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *largeImageURLString = [self.imageURLs[indexPath.row] stringByReplacingOccurrencesOfString:@"downsized_still" withString:@"original"];
    NSURL *largeImageURL = [NSURL URLWithString:largeImageURLString];
    NSString *imageTitle = self.imageTitles[indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailViewController.imageURL = largeImageURL;
    detailViewController.imageTitle = imageTitle;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
