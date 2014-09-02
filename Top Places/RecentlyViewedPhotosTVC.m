//
//  RecentlyViewedPhotosTVC.m
//  Top Places
//
//  Created by Appleseed on 9/1/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "RecentlyViewedPhotosTVC.h"
#import "RecentPhotos.h"

@interface RecentlyViewedPhotosTVC ()

@end

@implementation RecentlyViewedPhotosTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self retriveRecentPhotos];
}

- (void)retriveRecentPhotos
{
    self.photos = [RecentPhotos getRecentPhotos];
}

@end
