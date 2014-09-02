//
//  FlickrPhotosInPlaceTVC.m
//  Top Places
//
//  Created by Appleseed on 9/1/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "FlickrPhotosInPlaceTVC.h"
#import "FlickrFetcher.h"

@interface FlickrPhotosInPlaceTVC ()

@end

@implementation FlickrPhotosInPlaceTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhotosinPlace];
}

- (void)setPlace:(NSDictionary *)place
{
    _place = place;
    if (self.view.window) {
        [self fetchPhotosinPlace];
    }
}

- (void)fetchPhotosinPlace
{
    NSURL* url = [FlickrFetcher URLforPhotosInPlace:[self.place valueForKeyPath:FLICKR_PHOTO_PLACE_ID] maxResults:20];
    dispatch_queue_t fetchQ = dispatch_queue_create("fetch photos queue", NULL);
    dispatch_async(fetchQ, ^{
        NSData* jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary* propertyListResult = [NSJSONSerialization JSONObjectWithData:jsonResult options:0 error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = [propertyListResult valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        });
    });
}


@end
