//
//  MUProfileViewController.m
//  MatchedUp
//
//  Created by Alex Paul on 12/9/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "MUProfileViewController.h"

@interface MUProfileViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;

@end

@implementation MUProfileViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    PFFile *pictureFile = self.photo[kMUPhotoPictureKey];
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.profilePictureImageView.image = [UIImage imageWithData:data];
    }];
    PFUser *user = self.photo[kMUPhotoUserKey];
    self.locationLabel.text = user[kMUUserProfileKey][kMUUserProfileLocationKey];
    self.statusLabel.text = user[kMUUserProfileKey][kMUUserProfileRelationshipStatusKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", user[kMUUserProfileKey][kMUUserProfileAgeKey]];
    self.tagLineLabel.text = user[kMUUserProfileKey][kMUUserTagLineKey];
    NSLog(@"%@", user[kMUUserProfileKey][kMUUserTagLineKey]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
