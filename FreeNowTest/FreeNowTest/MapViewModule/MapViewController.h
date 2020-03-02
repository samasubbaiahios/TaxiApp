//
//  MapViewController.h
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 03/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class TaxiesFetcher;
@class TaxiData;
NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic) NSArray *locationsArray;

@end

NS_ASSUME_NONNULL_END
