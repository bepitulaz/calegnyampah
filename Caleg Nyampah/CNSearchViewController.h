//
//  CNSearchViewController.h
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNSearchViewController : UITableViewController<UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *originalData;
@property (nonatomic, strong) NSArray *searchData;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
