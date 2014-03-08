//
//  CNSaveViewController.h
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface CNSaveViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) UIImage *imageFromCam;
@property (nonatomic, strong) CLLocationManager *locManager;

@end
