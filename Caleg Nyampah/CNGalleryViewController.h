//
//  CNGalleryViewController.h
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CNGalleryViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locManager;

@end
