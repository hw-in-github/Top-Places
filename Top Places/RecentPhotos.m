//
//  RecentPhotos.m
//  Top Places
//
//  Created by Appleseed on 9/1/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "RecentPhotos.h"
#import "FlickrFetcher.h"

#define MOSTRECENTPHOTOS @"mostrecentphotos"

@implementation RecentPhotos

+ (NSArray *)getRecentPhotos
{
    NSArray* photos = [[NSUserDefaults standardUserDefaults] objectForKey:MOSTRECENTPHOTOS];
    if (!photos) {
        photos = [[NSArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:photos forKey:MOSTRECENTPHOTOS];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return photos;
}

+ (void)addPhoto:(NSDictionary *)photo
{
    NSString* photoID = [photo valueForKeyPath:FLICKR_PHOTO_ID];
    NSMutableArray* recentPhotos = [[RecentPhotos getRecentPhotos] mutableCopy];
    NSDictionary* photoToDelete = nil;
    for (NSDictionary* photo in recentPhotos) {
        if ([photoID isEqualToString:[photo valueForKeyPath:FLICKR_PHOTO_ID]]) {
            photoToDelete = photo;
            break;
        }
    }
    if (photoToDelete) {
        [recentPhotos removeObject:photoToDelete];
        [recentPhotos insertObject:photo atIndex:0];
    } else {
        [recentPhotos insertObject:photo atIndex:0];
    }
    [[NSUserDefaults standardUserDefaults] setObject:recentPhotos forKey:MOSTRECENTPHOTOS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
