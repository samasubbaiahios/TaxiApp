//
//  MapViewController.m
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 03/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

#import "MapViewController.h"
#import "FreeNowTest-Swift.h"
#import "Locations.h"
#import "MapAnnotation.h"
#import "MapVM.h"

@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) TaxiesFetcher *fetcher;
@property (nonatomic) MapVM *mapViewModel;
@property (nonatomic) CLLocation *uplatedLocation;
@property (nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsCompass = YES;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    
    self.locationLabel.text = @"Loading..";
    self.locationLabel.font = [UIFont systemFontOfSize:14];
    self.locationLabel.textColor = [UIColor darkGrayColor];
    [self getTaxiesInfo];
}

- (IBAction)locateMe:(id)sender {
    [self showCurrentLocation];
}
- (void)updateTitle:(NSString *)title {
    self.locationLabel.text = title;
}
- (void)getTaxiesInfo {
    self.fetcher = [TaxiesFetcher new];
    self.mapViewModel = [[MapVM alloc] init];
}
-(void)displayAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //if user has not given location services then set the default location to his company headquarter
    if ([[CLLocationManager class] locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            [self setDefaultLocation];
        } else {
            [self displayAnnotations];
        }
    }
    [self.view layoutIfNeeded];
}

-(void)showCurrentLocation {
    [self reloadInputViews];
    if ([[CLLocationManager class] locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            [self showMapPermissionDeniedAlert];
        } else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            if (self.currentLocation) {
                self.uplatedLocation = self.currentLocation;
                [self setMapViewZoomToDistanceMiles:2 withLocation:self.currentLocation];
            } else {
                if (self.currentLocation) {
                    [self displayAnnotations];
                    self.uplatedLocation = self.currentLocation;
                }
            }
        }
    }
}

-(void)showMapPermissionDeniedAlert {
    UIAlertAction *settingsAction =  [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertController *permissionDeniedAlertController = [UIAlertController alertControllerWithTitle:@"Permission Denied" message:@"To re-enable, please go to Settings and turn on Location Service for this app." preferredStyle:UIAlertControllerStyleAlert];
    [permissionDeniedAlertController addAction:settingsAction];
    [permissionDeniedAlertController addAction:cancelAction];
    
    [self presentViewController:permissionDeniedAlertController animated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

-(void)setDefaultLocation {

    MKMapRect mRect = self.mapView.visibleMapRect;
    Locations *locationInfo = [self.mapViewModel getDefaultLocation];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[locationInfo.firstLatitude doubleValue] longitude:[locationInfo.firstLongitude doubleValue]];
    [self setMapViewZoomToDistanceMiles:2 withLocation:location];
    [self displayAnnotations];
    if (self.locationsArray == nil) {
        [self updateMap:locationInfo];
    }
}

-(void)setMapViewZoomToDistanceMiles:(double)miles withLocation:(CLLocation *)location {
    MKCoordinateRegion region;
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * location.coordinate.latitude / 360.0) ));
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    region.span = span;
    region.center = location.coordinate;
    [self.mapView setRegion:region animated:YES];
}

- (void)updateMap:(Locations *)bounds {
    __weak typeof(self)weakSelf = self;
    [self.fetcher getTaxiesInfoWithLocation:bounds completion:^(BOOL isDone, NSArray<TaxiData *> * _Nonnull Taxies) {
        weakSelf.locationsArray = Taxies;
        [weakSelf displayAnnotations];
    }];

}

#pragma mark - MKMapView Delegates
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    [self.mapViewModel reverseGeocode:location withCompletion:^(BOOL isDone, NSString * _Nonnull address, NSError * _Nonnull error) {
        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                //alert for erro
                [weakSelf displayAlertWithTitle:@"Warning!" andMessage:error.localizedDescription];
            } else {
                [weakSelf updateTitle:address];
            }
        });
    }];
}
- (void)mapViewDidChangeVisibleRegion:(MKMapView *)mapView {
    MKMapRect mRect = self.mapView.visibleMapRect;
    [self updateMap:[self.mapViewModel getBoundingBox:mRect]];
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
//    [self setDefaultLocation];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[MapAnnotation class]]) {
        static NSString * const annotationReuseId = @"pinAnnotation";
        MKAnnotationView *mapPin = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationReuseId];
        if (mapPin == nil) {
            mapPin = [[MKAnnotationView alloc]init];
            mapPin.canShowCallout = NO;
            mapPin.draggable = NO;
            mapPin.image = [UIImage imageNamed:@"annotation"];
            mapPin.annotation = annotation;
        } else {
            mapPin.annotation = annotation;
        }
        return mapPin;
    }
    return nil;
}
#pragma mark - Geocoding
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!self.uplatedLocation) {
        self.currentLocation = [locations lastObject];
        if (self.locationsArray.count > 0) {
            self.uplatedLocation = self.locationsArray[0];
        } else {
            self.uplatedLocation = self.currentLocation;
        }
        [self displayAnnotations];
    } else {
        self.currentLocation = [locations lastObject];
    }
}

-(void)displayAnnotations {
    //API request is returing data even on ocean areas also
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakSelf.mapView.annotations) {
            [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
        }
        for(TaxiData *taxiInfo in weakSelf.locationsArray){
            MapAnnotation *annotation = [[MapAnnotation alloc]init];
            CLLocation *location = taxiInfo.locationDetail;
            [annotation setCoordinate:location.coordinate];
            [weakSelf.mapView addAnnotation:annotation];
        }
    });
}
@end
