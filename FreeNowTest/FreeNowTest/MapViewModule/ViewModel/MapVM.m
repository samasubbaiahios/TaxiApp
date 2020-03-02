//
//  MapVM.m
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 04/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

#import "MapVM.h"

@implementation MapVM

-(instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}
- (Locations *)getDefaultLocation {
    return [[Locations alloc] initWithDefault];
}
- (Locations *)getBoundingBox:(MKMapRect)mRect {
    
    CLLocationCoordinate2D bottomLeft = [self getSWCoordinate:mRect];
    CLLocationCoordinate2D topRight = [self getNECoordinate:mRect];
    NSString *latitude1 = [NSString stringWithFormat:@"%f", bottomLeft.latitude];
    NSString *longitude1 = [NSString stringWithFormat:@"%f", bottomLeft.longitude];
    NSString *latitude2 = [NSString stringWithFormat:@"%f", topRight.latitude];
    NSString *longitude2 = [NSString stringWithFormat:@"%f", topRight.longitude];
    Locations *locationData = [[Locations alloc] initWithLocationFirstLat:latitude1 FirstLon:longitude1 secondLat:latitude2 secondLon:longitude2];
    return locationData;
}
- (void)reverseGeocode:(CLLocation *)location withCompletion:(void (^)(BOOL isDone, NSString *address, NSError *error))completion {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSString *address = @"";
        if (error) {
            //alert for erro
            completion(NO, address, error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            NSNull *nullObject = [NSNull null];
            NSMutableArray *locationArray = [NSMutableArray new];
            [locationArray addObject:placemark.subThoroughfare ? placemark.subThoroughfare : nullObject];
            [locationArray addObject:placemark.thoroughfare ? placemark.thoroughfare : nullObject];
            [locationArray addObject:placemark.subLocality ? placemark.subLocality : nullObject];
            [locationArray addObject:placemark.locality ? placemark.locality : nullObject];
            [locationArray addObject:placemark.administrativeArea ? placemark.administrativeArea : nullObject];
            [locationArray addObject:placemark.country ? placemark.country : nullObject];
            [locationArray removeObjectIdenticalTo:[NSNull null]];
            NSMutableArray *removeDuplicates = [NSMutableArray new];
            for (NSString *str in locationArray) {
                if (![removeDuplicates containsObject:str]) {
                    [removeDuplicates addObject:str];
                }
            }
            address = [removeDuplicates componentsJoinedByString:@","];
            if(address.length > 0) {
                completion(YES, address, error);
            }
        }
    }];
}
-(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:mRect.origin.y];
}
-(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMinX(mRect) y:mRect.origin.y];
}
-(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:MKMapRectGetMaxY(mRect)];
}
-(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:mRect.origin.x y:MKMapRectGetMaxY(mRect)];
}

-(CLLocationCoordinate2D)getCoordinateFromMapRectanglePoint:(double)x y:(double)y{
    MKMapPoint swMapPoint = MKMapPointMake(x, y);
    return MKCoordinateForMapPoint(swMapPoint);
}

@end
