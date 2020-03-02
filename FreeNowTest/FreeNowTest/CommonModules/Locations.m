//
//  Locations.m
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 04/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

#import "Locations.h"

@implementation Locations

-(instancetype)initWithDefault {

    NSString *latitude1 = @"53.694865";
    NSString *longitude1 = @"9.757589";
    NSString *latitude2 = @"53.394655";
    NSString *longitude2 = @"10.099891";
    return [self initWithLocationFirstLat:latitude1 FirstLon:longitude1 secondLat:latitude2 secondLon:longitude2];
}

- (instancetype) initWithLocationFirstLat:(NSString *)firstLat
                                FirstLon:(NSString *)firstLon
                               secondLat:(NSString *)secondLat
                               secondLon:(NSString *)secondLong {
    self = [super init];
    
    if (self) {
        self.firstLatitude = firstLat;
        self.firstLongitude = firstLon;
        self.secondLatitude = secondLat;
        self.secondLongitude = secondLong;
    }
    
    return self;
}

@end
