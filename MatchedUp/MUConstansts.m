//
//  MUConstansts.m
//  MatchedUp
//
//  Created by Alex Paul on 12/8/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "MUConstansts.h"

@implementation MUConstansts

#pragma mark - User Class
NSString *const kMUUserProfileKey                       = @"profile";
NSString *const kMUUserProfileNameKey                   = @"name";
NSString *const kMUUserProfileFirstNameKey              = @"firstName";
NSString *const kMUUserProfileLocationKey               = @"location";
NSString *const kMUUserProfileGenderKey                 = @"gender";
NSString *const kMUUserProfileBirthdayKey               = @"birthday";
NSString *const kMUUserProfileInterestedInKey           = @"interestedIn";
NSString *const kMuuserProfilePictureURL                = @"pictureURL";
NSString *const kMUUserProfileRelationshipStatusKey     = @"relationshipStatus";
NSString *const kMUUserProfileAgeKey                    = @"age";
NSString *const kMUUserTagLineKey                       = @"tagline";

#pragma mark - Photo Class
NSString *const kMUPhotoClassKey                        = @"Photo";
NSString *const kMUPhotoUserKey                         = @"user";
NSString *const kMUPhotoPictureKey                      = @"image";

#pragma mark - Activity Class
NSString *const kMUActivityClassKey                     = @"Activity";
NSString *const kMUActivityTypeKey                      = @"type";
NSString *const kMUActivityFromUserKey                  = @"fromUser";
NSString *const kMUActivityToUserKey                    = @"toUser";
NSString *const kMUActivityPhotoKey                     = @"photo";
NSString *const kMUActivityLikeKey                      = @"like";
NSString *const kMUActivityDislikeKey                   = @"dislike";

#pragma mark - Settings
NSString *const kMUMenEnabledKey                        = @"men";
NSString *const kMUWomenEnabledKey                      = @"women";
NSString *const kMUSingleEnabledKey                     = @"single";
NSString *const kMUAgeMaxKey                            = @"ageMax";

@end
