//
//  CNDetailViewController.h
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CNDetailViewController : UIViewController

@property (nonatomic, strong) NSString *idCaleg;
@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, strong) PFGeoPoint *location;

@end
