//
//  PGContact.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

@import Foundation;
@import UIKit;
@import MagicalRecord;

@interface PGContact : NSManagedObject

@property (strong, nonatomic) NSString * _Nonnull firstName;
@property (strong, nonatomic) NSString * _Nonnull lastName;
@property (strong, nonatomic) NSString * _Nullable company;
@property (strong, nonatomic) NSString * _Nullable address;
@property (strong, nonatomic) NSString * _Nullable city;
@property (strong, nonatomic) NSString * _Nullable county;
@property (strong, nonatomic) NSString * _Nullable state;
@property (strong, nonatomic) NSString * _Nullable zip;
@property (strong, nonatomic) NSString * _Nullable phone;
@property (strong, nonatomic) NSString * _Nullable alternatePhone;
@property (strong, nonatomic) NSString * _Nullable email;
@property (strong, nonatomic) NSString * _Nullable website;
@property (strong, nonatomic) NSString * _Nullable imageData;
@property (strong, nonatomic, readonly, getter=profilePicture) UIImage * _Nullable profilePicture;
@property (strong, nonatomic, readonly, getter=fullName) NSString * _Nullable fullName;

#pragma mark - Instance Methods

- (void)save;
- (void)destroy;

#pragma mark - Class Methods

/**
 *  Fetches all the contacts.
 *
 *  @param completion Returns the contacts or an error if one occured.
 */
+ (void)fetchContactsWithCompletion:(void(^ _Nonnull)(NSArray<PGContact *>  * _Nullable contacts, NSError * _Nullable error))completion;
@end
