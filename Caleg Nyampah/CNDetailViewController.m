//
//  CNDetailViewController.m
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import "CNDetailViewController.h"
#import <AFNetworking/AFNetworking.h>


@interface CNDetailViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *photoCaleg;
@property (nonatomic, strong) IBOutlet UILabel *nameCaleg;
@property (nonatomic, strong) IBOutlet UILabel *dapilCaleg;
@property (nonatomic, strong) IBOutlet UILabel *partaiCaleg;
@property (nonatomic, strong) IBOutlet UIImageView *sampahCaleg;
@end

@implementation CNDetailViewController

@synthesize idCaleg, imageFile, location;
@synthesize photoCaleg, nameCaleg, dapilCaleg, partaiCaleg, sampahCaleg;

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
	// start downloading the detail of caleg
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [NSString stringWithFormat:@"http://api.pemiluapi.org/candidate/api/caleg/%@?apiKey=7f65b68695deacd50f405f63477aec8f", self.idCaleg];
    
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *detailArray = [[[responseObject objectForKey:@"data"] objectForKey:@"results"] objectForKey:@"caleg"];
        
        // get photo
        NSString *stringUrl = [[detailArray objectAtIndex:0] objectForKey:@"foto_url"];
        NSURL *imageURL = [NSURL URLWithString:stringUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *imageCaleg = [UIImage imageWithData:imageData];
        self.photoCaleg.image = imageCaleg;
        
        // get sampah photo
        
        NSData *imageSampahData = [self.imageFile getData];
        UIImage *imageSampahCaleg = [UIImage imageWithData:imageSampahData];
        self.sampahCaleg.image = imageSampahCaleg;
        
        // get label
        self.nameCaleg.text = [[detailArray objectAtIndex:0] objectForKey:@"nama"];
        self.partaiCaleg.text = [NSString stringWithFormat:@"Partai %@", [[detailArray objectAtIndex:0] objectForKey:@"partai"]];
        self.dapilCaleg.text = [NSString stringWithFormat:@"Dapil %@", [[[detailArray objectAtIndex:0] objectForKey:@"dapil"] objectForKey:@"nama"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
