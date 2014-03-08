//
//  CNStatisticViewController.m
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/9/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import "CNStatisticViewController.h"
#import "PNChart.h"

@interface CNStatisticViewController ()

@end

@implementation CNStatisticViewController

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
	
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // start downloading the list of caleg
        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //For BarChart
                PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 120.0, SCREEN_WIDTH, 200.0)];
                
                // create array name
                NSMutableArray *arrayName = [[NSMutableArray alloc] init];
                for (NSUInteger i = 0; i < objects.count; i++) {
                    if(i < 4) {
                        [arrayName addObject:[[objects objectAtIndex:i] objectForKey:@"calegName"]];
                    }
                }
                
                NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:arrayName];
                NSMutableArray *xArray = [[NSMutableArray alloc] init];
                NSMutableArray *yArray = [[NSMutableArray alloc] init];
                for (id item in countedSet)
                {
                    [xArray addObject:item];
                    [yArray addObject:[NSNumber numberWithInt:[countedSet countForObject:item]]];
                }
                
                [barChart setXLabels:xArray];
                [barChart setYValues:yArray];
                [barChart strokeChart];
                
                [self.view addSubview:barChart];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
    } else {
        NSLog(@"You are not login");
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
