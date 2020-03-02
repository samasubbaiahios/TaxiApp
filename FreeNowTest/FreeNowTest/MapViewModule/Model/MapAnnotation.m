//
//  MapAnnotation.m
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 04/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize coordinate;
@synthesize location;

// Called as a result of dragging an annotation view.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

- (void)setLocation:(NSString *)newLocation {
    location = newLocation;
}

@end
