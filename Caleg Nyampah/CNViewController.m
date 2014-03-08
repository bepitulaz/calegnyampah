//
//  CNViewController.m
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import "CNViewController.h"
#import "CNSaveViewController.h"

@interface CNViewController ()
@property (nonatomic, strong) UIImage *imageFromCam;
- (IBAction)cameraTapped:(id)sender;
@end

@implementation CNViewController

@synthesize avatarImg, photoCount, calegCount, dayCount, menuView, avatarName;
@synthesize tableData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// initiate the array
    self.tableData = @[@"Eksplorasi", @"Koleksi Pribadi", @"Caleg Juara"];
    
    [PFUser logInWithUsernameInBackground:@"bepitulaz" password:@"l3tm31nd0ng"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button callbak
- (IBAction)cameraTapped:(id)sender
{
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.delegate = self;
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.allowsEditing = YES;
    cameraUI.editing = YES;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableData && self.tableData.count) {
        return self.tableData.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"menu";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - camera delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // saving the image
    self.imageFromCam = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:NO completion:^(void) {
        [self performSegueWithIdentifier:@"saveSegue" sender:self];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"saveSegue"]) {
        UINavigationController *dest = (UINavigationController *)segue.destinationViewController;
        CNSaveViewController *saveVC = [[CNSaveViewController alloc] init];
        saveVC = (CNSaveViewController *)dest.topViewController;
        saveVC.imageFromCam = self.imageFromCam;
    }
}

@end
