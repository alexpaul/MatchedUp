//
//  MUConstansts.h
//  MatchedUp
//
//  Created by Alex Paul on 12/8/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUConstansts : NSObject

#pragma mark - User Class
extern NSString *const kMUUserProfileKey;
extern NSString *const kMUUserProfileNameKey;
extern NSString *const kMUUserProfileFirstNameKey;
extern NSString *const kMUUserProfileLocationKey;
extern NSString *const kMUUserProfileGenderKey;
extern NSString *const kMUUserProfileBirthdayKey;
extern NSString *const kMUUserProfileInterestedInKey;
extern NSString *const kMuuserProfilePictureURL;
extern NSString *const kMUUserProfileRelationshipStatusKey;
extern NSString *const kMUUserProfileAgeKey;
extern NSString *const kMUUserTagLineKey;

#pragma mark - Photo Class
extern NSString *const kMUPhotoClassKey;
extern NSString *const kMUPhotoUserKey;
extern NSString *const kMUPhotoPictureKey;

#pragma mark - Activity
extern NSString *const kMUActivityClassKey;
extern NSString *const kMUActivityTypeKey;
extern NSString *const kMUActivityFromUserKey;
extern NSString *const kMUActivityToUserKey;
extern NSString *const kMUActivityPhotoKey;
extern NSString *const kMUActivityLikeKey;
extern NSString *const kMUActivityDislikeKey;

#pragma mark - Settings
extern NSString *const kMUMenEnabledKey;
extern NSString *const kMUWomenEnabledKey;
extern NSString *const kMUSingleEnabledKey;
extern NSString *const kMUAgeMaxKey;

@end
