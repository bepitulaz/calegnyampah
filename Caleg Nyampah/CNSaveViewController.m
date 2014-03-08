//
//  CNSaveViewController.m
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import "CNSaveViewController.h"
#import "CNSearchViewController.h"

@interface CNSaveViewController ()
@property (nonatomic, strong) UILabel *namaCaleg;
@property (nonatomic, strong) UILabel *lokasiCaleg;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *idCaleg;
@property (nonatomic, strong) CLGeocoder *geocoder;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;
@end

@implementation CNSaveViewController

@synthesize imageFromCam;
@synthesize namaCaleg, lokasiCaleg;
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
	// Do any additional setup after loading the view.
    
    UIImageView *showImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 73, 300, 300)];
    showImage.image = self.imageFromCam;
    [self.view addSubview:showImage];
    
    // information
    self.namaCaleg = [[UILabel alloc] initWithFrame:CGRectMake(20, 295, 280, 37)];
    self.namaCaleg.text = @"Sampah siapa nih?";
    self.namaCaleg.font = [UIFont boldSystemFontOfSize:25];
    self.namaCaleg.textColor = [UIColor whiteColor];
    [self.view addSubview:self.namaCaleg];
    
    self.lokasiCaleg = [[UILabel alloc] initWithFrame:CGRectMake(20, 340, 239, 16)];
    self.lokasiCaleg.text = @"Lokasi di mana?";
    self.lokasiCaleg.font = [UIFont boldSystemFontOfSize:16];
    self.lokasiCaleg.textColor = [UIColor whiteColor];
    [self.view addSubview:self.lokasiCaleg];
    
    // add observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveNotification:)
                                                 name:@"CalegSelected"
                                               object:nil];
    
    // start using the location
    [self currentLocationFromGPS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - callback
- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NO];
}

- (IBAction)saveTapped:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // saving image into parse
        NSData *imageData = UIImagePNGRepresentation(self.imageFromCam);
        PFFile *imageFile = [PFFile fileWithName:@"caleg.png" data:imageData];
        
        // saving location
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
        
        PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
        userPhoto[@"imageName"] = self.namaCaleg.text;
        userPhoto[@"imageFile"] = imageFile;
        userPhoto[@"location"] = point;
        userPhoto[@"calegName"] = self.namaCaleg.text;
        userPhoto[@"locationString"] = self.lokasiCaleg.text;
        userPhoto[@"idCaleg"] = self.idCaleg;
        [userPhoto saveInBackground];
        
        // saving image
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // Handle success or failure here ...
        } progressBlock:^(int percentDone) {
            // Update your progress spinner here. percentDone will be between 0 and 100.
            NSLog(@"%d", percentDone);
        }];
    } else {
        // show the signup or login screen
        NSLog(@"FAILED TO LOGIN");
    }
    [self dismissViewControllerAnimated:YES completion:NO];
}

#pragma mark - notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"CalegSelected"]) {
        self.idCaleg = [notification.object objectForKey:@"id"];
        self.namaCaleg.text = [notification.object objectForKey:@"nama"];
    }
}

#pragma mark - corelocation delegate
- (void)currentLocationFromGPS
{
    self.locManager = [[CLLocationManager alloc] init];
    [self.locManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [self.locManager setDelegate:self];
    [self.locManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    // save the location into db
    self.latitude = [[locations objectAtIndex:0] coordinate].latitude;
    self.longitude = [[locations objectAtIndex:0] coordinate].longitude;
    
    NSLog(@"%f, %f", self.latitude, self.longitude);
    
    // reverse geocoding
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    
    // Reverse Geocode a CLLocation to a CLPlacemark
    [self.geocoder reverseGeocodeLocation:currentLoc completionHandler:^(NSArray *placemarks, NSError *error){
       // Make sure the geocoder did not produce an error
       // before continuing
       if(!error){
           // Iterate through all of the placemarks returned
           // and output them to the console
           for(CLPlacemark *placemark in placemarks){
               self.lokasiCaleg.text = [NSString stringWithFormat:@"%@, %@", [placemark locality], [placemark administrativeArea]];
           }
       } else{
           // Our geocoder had an error, output a message
           // to the console
           NSLog(@"There was a reverse geocoding error\n%@", [error localizedDescription]);
       }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

#pragma mark - passing parameter
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"searchCalegSegue"]) {
        CNSaveViewController *saveVC = [segue destinationViewController];
        saveVC.latitude = self.latitude;
        saveVC.longitude = self.longitude;
    }
}

@end
