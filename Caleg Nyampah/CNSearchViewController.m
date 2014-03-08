//
//  CNSearchViewController.m
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import "CNSearchViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface CNSearchViewController ()

@end

@implementation CNSearchViewController

@synthesize searchBar, originalData, searchData;
@synthesize latitude, longitude;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // start downloading the list of caleg
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [NSString stringWithFormat:@"http://api.pemiluapi.org/geographic/api/caleg?apiKey=7f65b68695deacd50f405f63477aec8f&lat=%f&long=%f", self.latitude, self.longitude];
    
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.originalData = [[[[responseObject objectForKey:@"data"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"caleg"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSUInteger rows = 0;
    
    if (tableView == self.tableView) {
        rows = [self.originalData count];
    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if([self.searchData count] > 0) {
            rows = [self.searchData count];
        } else {
            rows = 0;
        }
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"searchCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    // Configure the cell...
    if (tableView == self.tableView) {
        cell.textLabel.text = [[self.originalData objectAtIndex:indexPath.row] objectForKey:@"nama"];
    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = [[self.searchData objectAtIndex:indexPath.row] objectForKey:@"nama"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView) {
        NSDictionary *dataCalegToPass = [NSDictionary dictionaryWithObjectsAndKeys:[[self.originalData objectAtIndex:indexPath.row] objectForKey:@"nama"], @"nama", [[self.originalData objectAtIndex:indexPath.row] objectForKey:@"id"], @"id", nil];
        [self postNotification:@"CalegSelected" withObject:dataCalegToPass];
    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
         NSDictionary *dataCalegToPass = [NSDictionary dictionaryWithObjectsAndKeys:[[self.searchData objectAtIndex:indexPath.row] objectForKey:@"nama"], @"nama", [[self.searchData objectAtIndex:indexPath.row] objectForKey:@"id"], @"id", nil];
        [self postNotification:@"CalegSelected" withObject:dataCalegToPass];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - search display controller delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchData = [self.originalData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K contains[c] %@", @"nama", searchString]];
    return YES;
}

#pragma mark - notification area
- (void)sendNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postNotification:(NSString *)notification withObject:(id)obj
{
    NSNotification *n = [NSNotification notificationWithName:notification object:obj];
    [self performSelectorOnMainThread:@selector(sendNotification:) withObject:n waitUntilDone:NO];
}

@end
