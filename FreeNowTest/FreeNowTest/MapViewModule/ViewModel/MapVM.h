//
//  MapVM.h
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 04/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "Locations.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapVM : NSObject

-(instancetype)init;
- (Locations *)getDefaultLocation;
- (Locations *)getBoundingBox:(MKMapRect)mRect;
- (void)reverseGeocode:(CLLocation *)location withCompletion:(void (^)(BOOL isDone, NSString *address, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
