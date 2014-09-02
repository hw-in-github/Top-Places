//
//  TopFlickrPlacesTVC.m
//  Top Places
//
//  Created by Appleseed on 8/31/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "TopFlickrPlacesTVC.h"
#import "FlickrFetcher.h"

@interface TopFlickrPlacesTVC ()

@property (weak, nonatomic) IBOutlet UIRefreshControl *refeshControl;

@end

@implementation TopFlickrPlacesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.refeshControl addTarget:self action:@selector(startFetchTopPlaces) forControlEvents:UIControlEventValueChanged];
    [self startFetchTopPlaces];
}

- (IBAction)startFetchTopPlaces
{
    NSURL* url = [FlickrFetcher URLforTopPlaces];
    [self.refeshControl beginRefreshing];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Fetch Top Places", NULL);
    dispatch_async(fetchQ, ^{
        NSData* jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary* propertyListResult = [NSJSONSerialization JSONObjectWithData:jsonResult options:0 error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refeshControl endRefreshing];
            self.places = [propertyListResult valueForKeyPath:FLICKR_RESULTS_PLACES];
        });
    });
}


@end
