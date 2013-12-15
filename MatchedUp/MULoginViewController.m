//
//  MULoginViewController.m
//  MatchedUp
//
//  Created by Alex Paul on 12/6/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "MULoginViewController.h"

@interface MULoginViewController () <NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableData *imageData;

@end

@implementation MULoginViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activityIndicator.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkIfUserIsLoggedIn];
}

#pragma mark - Button Actions
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        if (!user) {
            if (!error) {
                // Login cancelled
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"The Facebook Log in was Cancelled." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }else{
                // There was an Error
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
        }else{
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
        }
    }];
}

#pragma mark - Helper Methods
- (void)checkIfUserIsLoggedIn
{
    // Check if the user is linked and signed to Facebook, if so bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self updateUserInformation];
        
        NSLog(@"The user is already signed in");
        [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
    }else{
        NSLog(@"User needs to Log in");
    }
}

- (void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {            
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            // Create URL
            NSString *facebookID = userDictionary[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
            
            if (userDictionary[@"name"]) {
                userProfile[kMUUserProfileNameKey] = userDictionary[@"name"];
            }
            
            if (userDictionary[@"first_name"]) {
                userProfile[kMUUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            
            if (userDictionary[@"location"][@"name"]) {
                userProfile[kMUUserProfileLocationKey] = userDictionary[@"location"][@"name"];
            }
            
            if (userDictionary[@"gender"]) {
                userProfile[kMUUserProfileGenderKey] = userDictionary[@"gender"];
            }
            
            if (userDictionary[@"birthday"]) {
                userProfile[kMUUserProfileBirthdayKey] = userDictionary[@"birthday"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                NSDate *now = [NSDate date];
                NSDate *date = [dateFormatter dateFromString:userDictionary[@"birthday"]];
                NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                int age = seconds / 31536000;
                userProfile[kMUUserProfileAgeKey] = @(age);
            }
            
            if (userDictionary[@"interesed_in"]) {
                userProfile[kMUUserProfileInterestedInKey] = userDictionary[@"interested_in"];
            }
            
            if (userDictionary[@"relationship_status"]) {
                userProfile[kMUUserProfileRelationshipStatusKey] = userDictionary[@"relationship_status"];
            }
            
            if ([pictureURL absoluteString]) {
                userProfile[kMuuserProfilePictureURL] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:kMUUserProfileKey];
            [[PFUser currentUser] saveInBackground];
            
            // Request Image
            //[self requestImage];
        }else{
            NSLog(@"Error in FB Request %@", error);
        }
    }];
}

- (void)uploadPFFileToParse:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    if (!imageData) {
        NSLog(@"imageData was not found.");
        return;
    }
    PFFile *photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *photo = [PFObject objectWithClassName:kMUPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kMUPhotoUserKey];
            [photo setObject:photoFile forKey:kMUPhotoPictureKey];
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Photo saved successfully.");
            }];
        }
    }];
}

- (void)requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey];
    [query whereKey:kMUPhotoUserKey equalTo:[PFUser currentUser]]; // only photos from the current user
    //[query whereKey:kMUPhotoUserKey notEqualTo:[PFUser currentUser]];
    
    PFUser *user = [PFUser currentUser];
    
    // Use Count
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0) {
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureURL = [NSURL URLWithString:user[kMUUserProfileKey][kMuuserProfilePictureURL]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
            
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (!urlConnection) {
                NSLog(@"Failed to Download Photo");
            }
        }
    }];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // As Chunks of Data are being received we build our Data file
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // All Data has been downloaded, now we can set the image in the header image view
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];
}

@end
