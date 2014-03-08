//
//  CNMapAnnotation.h
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/9/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface CNMapAnnotation : NSObject<MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    NSString *idCaleg;
    PFFile *imageFile;
    PFGeoPoint *locationCaleg;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *idCaleg;
@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, strong) PFGeoPoint *locationCaleg;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
