//
//  FlickrPlacesTVC.m
//  Top Places
//
//  Created by Appleseed on 8/31/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "FlickrPlacesTVC.h"
#import "FlickrFetcher.h"
#import "FlickrPhotosInPlaceTVC.h"

@interface FlickrPlacesTVC ()
@property (nonatomic, strong)NSMutableDictionary* countries;
@property (nonatomic, strong)NSArray* sortedCountryNames;
@end

@implementation FlickrPlacesTVC

#pragma mark - property

- (NSMutableDictionary *)countries
{
    if (!_countries) {
        _countries = [[NSMutableDictionary alloc]init];
    }
    return _countries;
}

- (void)setPlaces:(NSArray *)places
{
    _places = places;
    self.countries = nil;
    
    for (NSDictionary* place in places) {
        NSString* placeAsString = [place valueForKeyPath:FLICKR_PLACE_NAME];
        NSString* country = [[placeAsString componentsSeparatedByString:@","] lastObject];
        NSMutableArray* placesInCountry = self.countries[country];
        if (!placesInCountry) {
            placesInCountry = [[NSMutableArray alloc]init];
        }
        [placesInCountry addObject:place];
        [self.countries setObject:placesInCountry forKey:country];
    }
    NSArray* countryKeys = [self.countries.allKeys mutableCopy];
    self.sortedCountryNames = [countryKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    NSMutableDictionary* sortedCountries = [[NSMutableDictionary alloc]init];
    for (NSString* key in self.sortedCountryNames) {
        NSArray* placesToSort= self.countries[key];
        sortedCountries[key] = [placesToSort sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString* city1 = [obj1 valueForKeyPath:FLICKR_PLACE_NAME];
            NSString* city2 = [obj2 valueForKeyPath:FLICKR_PLACE_NAME];
            return [city1 compare:city2];
        }];
    }
    self.countries = sortedCountries;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.sortedCountryNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray* places = self.countries[self.sortedCountryNames[section]];
    return places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Place Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary* place = [self placeAtIndexPath:indexPath];
    NSMutableArray* placeAsArray = [[[place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","] mutableCopy];
    
    cell.textLabel.text = [placeAsArray firstObject];
    [placeAsArray removeObjectsInRange:NSMakeRange(0, 1)];
    cell.detailTextLabel.text = [placeAsArray componentsJoinedByString:@", "];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sortedCountryNames[section];
}


- (NSDictionary *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* key = self.sortedCountryNames[indexPath.section];
    NSArray* placesAsArray = self.countries[key];
    return placesAsArray[indexPath.row];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[FlickrPhotosInPlaceTVC class]]) {
        if ([segue.identifier isEqualToString:@"show flickr photos"]) {
            FlickrPhotosInPlaceTVC* photosTVC = segue.destinationViewController;
            NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
            photosTVC.place = [self placeAtIndexPath:indexPath];
        }
    }
}


@end
