//
//  CNViewController.h
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CNViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *avatarImg;
@property (nonatomic, strong) IBOutlet UILabel *photoCount;
@property (nonatomic, strong) IBOutlet UILabel *calegCount;
@property (nonatomic, strong) IBOutlet UILabel *dayCount;
@property (nonatomic, strong) IBOutlet UILabel *avatarName;
@property (nonatomic, strong) IBOutlet UITableView *menuView;
@property (nonatomic, strong) NSArray *tableData;
@end
