//
//  CNViewController.m
//  Caleg Nyampah
//
//  Created by Asep Bagja on 3/8/14.
//  Copyright (c) 2014 asep.co. All rights reserved.
//

#import "CNViewController.h"
#import "CNSaveViewController.h"
#import <OpenEars/LanguageModelGenerator.h>
#import "DDHelper.h"

@interface CNViewController ()
@property (nonatomic, strong) UIImage *imageFromCam;
@property (nonatomic, strong) UIImagePickerController *cameraUI;

- (IBAction)cameraTapped:(id)sender;
@end

@implementation CNViewController

@synthesize avatarImg, photoCount, calegCount, dayCount, menuView, avatarName;
@synthesize tableData;
@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // change color
    [self.navigationController navigationBar].barTintColor = [DDHelper colorFromRGB:@"#db5548"];
    [self.navigationController navigationBar].tintColor = [DDHelper colorFromRGB:@"#ffffff"];
    self.view.backgroundColor = [DDHelper colorFromRGB:@"f0f0f0"];
    
    // language generator
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    
    NSArray *words = [NSArray arrayWithObjects:@"CAMERA", @"TANDAIN", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to create a Spanish language model instead of an English one.
    
    
    NSDictionary *languageGeneratorResults = nil;
    
    NSString *lmPath = nil;
    NSString *dicPath = nil;
	
    if([err code] == noErr) {
        
        languageGeneratorResults = [err userInfo];
		
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    
    [self.openEarsEventsObserver setDelegate:self];
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [PFUser logInWithUsernameInBackground:@"username" password:@"password"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
                                            [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                                                if (!error) {
                                                    // The count request succeeded. Log the count
                                                    self.photoCount.text = [NSString stringWithFormat:@"%d", count];
                                                    
                                                } else {
                                                    // The request failed
                                                }
                                            }];
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
    [self showTheCam];
}

- (void)cameraByVoice
{
    [self showTheCam];
}

- (void)showTheCam
{
    self.cameraUI = [[UIImagePickerController alloc] init];
    self.cameraUI.delegate = self;
    self.cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraUI.allowsEditing = YES;
    self.cameraUI.editing = YES;
    
    [self presentViewController:self.cameraUI animated:YES completion:nil];
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

#pragma mark - speech recognition
- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

#pragma mark - Open ears delegate method
- (void)pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    
    if([hypothesis isEqualToString:@"CAMERA"]) {
        [self performSelector:@selector(cameraByVoice)];
    }
    
    if([hypothesis isEqualToString:@"TANDAIN"]) {
        [self.cameraUI takePicture];
    }
}

- (void)pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void)pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void)pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void)pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void)pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void)pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void)pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void)pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void)pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void)pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}
- (void)testRecognitionCompleted {
	NSLog(@"A test file that was submitted for recognition is now complete.");
}

@end
