//
//  CNGalleryViewController.m
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import "CNGalleryViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "CNDetailViewController.h"
#import "CNMapAnnotation.h"

@interface CNGalleryViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic) MKCoordinateRegion newRegion;
@end

@implementation CNGalleryViewController

@synthesize locManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // set map view
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomEnabled:YES];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // start downloading the list of caleg
        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // create annotation
                NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
                for(CNMapAnnotation *record in objects) {
                    CNMapAnnotation *temp = [[CNMapAnnotation alloc] init];
                    
                    [temp setTitle:[record valueForKey:@"imageName"]];
                    [temp setSubtitle:[record valueForKey:@"locationString"]];
                    PFGeoPoint *geoPoint = [record valueForKey:@"location"];
                    [temp setCoordinate:CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)];
                    [temp setIdCaleg:[record valueForKey:@"idCaleg"]];
                    [temp setLocationCaleg:geoPoint];
                    
                    PFFile *imageFile = [record valueForKey:@"imageFile"];
                    [temp setImageFile:imageFile];
                    [annotationArray addObject:temp];
                }
                
                // add annotation using multithreading
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.mapView addAnnotations:annotationArray];
                        
                    });
                });
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        [self currentLocationFromGPS];
    } else {
        NSLog(@"You are not login");
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView setRegion:self.newRegion animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)currentLocationFromGPS
{
    self.locManager = [[CLLocationManager alloc] init];
    [self.locManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [self.locManager setDelegate:self];
    [self.locManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // set the zoom level
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[locations objectAtIndex:0] coordinate].latitude, [[locations objectAtIndex:0] coordinate].longitude);
    region.span = span;
    region.center = location;
    self.newRegion = region;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"detailCalegSegue" sender:view];
}

#pragma mark - change segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"detailCalegSegue"]) {
        CNDetailViewController *detailVC = [segue destinationViewController];
        detailVC.idCaleg = [[sender annotation] idCaleg];
        detailVC.imageFile = [[sender annotation] imageFile];
        detailVC.location = [[sender annotation] locationCaleg];
    }
}

@end
