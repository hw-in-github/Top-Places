//
//  RecentPhotos.h
//  Top Places
//
//  Created by Appleseed on 9/1/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotos : NSObject

+ (void)addPhoto:(NSDictionary *)photo;
+ (NSArray *)getRecentPhotos;

@end
