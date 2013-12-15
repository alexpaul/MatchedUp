//
//  MUHomeViewController.m
//  MatchedUp
//
//  Created by Alex Paul on 12/9/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "MUHomeViewController.h"
#import "MUTestUser.h"
#import "MUProfileViewController.h"

@interface MUHomeViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) PFObject *photo;
@property (nonatomic, strong) NSMutableArray *activities;

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;

@end

@implementation MUHomeViewController

#pragma mark - View Life Cycle
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
	// Do any additional setup after loading the view.
    
    //[MUTestUser saveTestUserToParse];
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey];
    [query whereKey:kMUPhotoUserKey notEqualTo:[PFUser currentUser]];
    [query includeKey:kMUPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.photos = objects;
            [self queryForCurrentPhotoIndex]; 
        }else{
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
    
}

- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender
{
    
}

- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkDislike];
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:self];
}

#pragma mark - Helper Methods
- (void)queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex]; // set photo
        PFFile *file = self.photo[kMUPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }else{
                NSLog(@"%@", error);
            }
        }];
        
        // Doing a Query for Activity Type (like, dislike)
        PFQuery *queryForLike = [PFQuery queryWithClassName:kMUActivityClassKey];
        [queryForLike whereKey:kMUActivityTypeKey equalTo:kMUActivityLikeKey];
        [queryForLike whereKey:kMUActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kMUActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kMUActivityClassKey];
        [queryForDislike whereKey:kMUActivityTypeKey equalTo:kMUActivityDislikeKey];
        [queryForDislike whereKey:kMUActivityPhotoKey equalTo:self.photo];
        [queryForDislike whereKey:kMUActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]]; // simultaneous queries (join)
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.activities = [objects mutableCopy];
                
                if ([self.activities count] == 0) {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = NO;
                }else{ // there is an activity
                    PFObject *activity = self.activities[0];
                    if ([activity[kMUActivityTypeKey] isEqualToString:kMUActivityLikeKey]) {
                        self.isLikedByCurrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    }else if ([activity[kMUActivityTypeKey] isEqualToString:kMUActivityDislikeKey]){
                        self.isLikedByCurrentUser = NO;
                        self.isDislikedByCurrentUser = YES;
                    }else{
                        // Some other activity
                    }
                }
                self.likeButton.enabled = YES;
                self.dislikeButton.enabled = YES;
                self.infoButton.enabled = YES; 
            }
        }];
    }
}

- (void)updateView
{
    self.firstNameLabel.text = self.photo[kMUPhotoUserKey][kMUUserProfileKey][kMUUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[kMUPhotoUserKey][kMUUserProfileKey][kMUUserProfileAgeKey]];
    self.tagLineLabel.text = self.photo[kMUPhotoUserKey][kMUUserTagLineKey];
}

- (void)setupNextPhoto
{
    if (self.currentPhotoIndex + 1 < [self.photos count]) {
        self.currentPhotoIndex++;
        [self queryForCurrentPhotoIndex];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No More Users to View" message:@"Check back later for more People" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)saveLike
{
    PFObject *likeActivity = [PFObject objectWithClassName:kMUActivityClassKey];
    [likeActivity setObject:kMUActivityLikeKey forKey:kMUActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kMUActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kMUPhotoUserKey] forKey:kMUActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kMUActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        [self setupNextPhoto];
    }];
}

- (void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kMUActivityClassKey];
    [dislikeActivity setObject:kMUActivityDislikeKey forKey:kMUActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kMUActivityFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kMUPhotoUserKey] forKey:kMUActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kMUActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isDislikedByCurrentUser = YES;
        self.isLikedByCurrentUser = NO;
        [self.activities addObject:dislikeActivity];
        [self setupNextPhoto];
    }];
}

- (void)checkLike
{
    if (self.isLikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser) {
        for (PFObject *activities in self.activities) {
            [activities deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else {
        [self saveLike];
    }
}

- (void)checkDislike
{
    if (self.isDislikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    }
    else if (self.isLikedByCurrentUser) {
        for (PFObject *activities in self.activities) {
            [activities deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else{
        [self saveDislike];
    }
}

#pragma mark - Prepare For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[MUProfileViewController class]]) {
            MUProfileViewController *profileVC = [segue destinationViewController];
            profileVC.photo = self.photo;
        }
    }
}

@end
