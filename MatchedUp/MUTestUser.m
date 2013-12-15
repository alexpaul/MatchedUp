//
//  MUTestUser.m
//  MatchedUp
//
//  Created by Alex Paul on 12/15/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "MUTestUser.h"

@implementation MUTestUser

+ (void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    
    newUser.username = @"Anh";
    newUser.password = @"password1234";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSDictionary *profile = @{kMUUserProfileAgeKey: @35,
                                      kMUUserProfileBirthdayKey : @"04/04/1978",
                                      kMUUserProfileFirstNameKey : @"Anh",
                                      kMUUserProfileLocationKey: @"Astoria, New York",
                                      kMUUserProfileNameKey : @"Anh Phan",
                                      kMUUserProfileRelationshipStatusKey : @"Married",
                                      kMUUserTagLineKey : @"sky's the limit"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    UIImage *profileImage = [UIImage imageNamed:@"anh.jpg"];
                    NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                    
                    PFFile *photoFile = [PFFile fileWithData:imageData];
                    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            PFObject *photo = [PFObject objectWithClassName:kMUPhotoClassKey];
                            [photo setObject:newUser forKey:kMUPhotoUserKey];
                            [photo setObject:photoFile forKey:kMUPhotoPictureKey];
                            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    NSLog(@"Photo saved successfully."); 
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

@end
