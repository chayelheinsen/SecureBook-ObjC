//
//  PGContact.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "PGContact.h"
#import "NSString+Utilities.h"
#import "CDFInitialsAvatar.h"
@import AFNetworking;

@implementation PGContact
@dynamic firstName, lastName, company, address, city, county, state, zip, phone, alternatePhone, email, website, imageData;

#pragma mark - Instance Methods

- (UIImage * _Nullable)profilePicture {
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:self.imageData options:0];
    
    if (imageData) {
        return [UIImage imageWithData:imageData];
    } else {
        CDFInitialsAvatar *initialsAvatar = [[CDFInitialsAvatar alloc] initWithRect:CGRectMake(0, 0, 50, 50) fullName:self.fullName];
        return initialsAvatar.imageRepresentation;
    }
}

- (NSString * _Nullable)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

#pragma mark - Class Methods

/**
 *  Fetches all the contacts.
 *
 *  @param completion Returns the contacts or an error if one occured.
 */
+ (void)fetchContactsWithCompletion:(void(^ _Nonnull)(NSArray<PGContact *>  * _Nullable contacts, NSError * _Nullable error))completion {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // We grab the ssl certificate.
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"sndr" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:certPath];
    NSSet<NSData *> *cert = [NSSet setWithObject:certData];
    
    // Create a new policy with our cert to allow SSL Pinning.
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cert];
    
    NSURL *URL = [NSURL URLWithString:@"https://sndr.com/testDataJson.txt"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
            completion(nil, error);
        } else {
            //NSLog(@"%@ %@", response, responseObject);
            
            // Convert the json data to an array of NSDictionarys.
            NSError *jsonError;
            NSArray *contactDicts = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
            //NSLog(@"JSON Dict: %@", contactDicts);
            
            NSMutableArray<PGContact *> *contacts = [NSMutableArray new];
            
            // Delete all th old contacts
            [PGContact MR_truncateAll];
            [PGContact MR_truncateAllInContext:[NSManagedObjectContext MR_rootSavingContext]];
            
            // Create PGContact's from the array of dictionarys.
            for (NSDictionary *contactDict in contactDicts) {
                // Create the contact.
                PGContact *contact = [PGContact map:contactDict];
                
                // Make sure that we got a contact back and append it to the array.
                if (contact) {
                    [contact save];
                    [contacts addObject:contact];
                }
            }
            
            // Alphabetically sort the contacts by name.
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
            contacts = [[contacts sortedArrayUsingDescriptors:@[sort]] mutableCopy];
            completion(contacts, nil);
        }
    }];
    
    // Make the request!
    [dataTask resume];
}

#pragma mark - Private Instance Methods


#pragma mark - Private Class Methods

/**
 *  Maps a dictionary to a PGContact.
 *
 *  @param dict The dictionary of JSON values.
 *
 *  @return A new PGContact or nil if one could not be created.
 */
+ (PGContact * _Nullable)map:(NSDictionary * _Nonnull)dict {
    //NSLog(@"%@", dict);
    
    PGContact *contact = [PGContact MR_createEntityInContext:[NSManagedObjectContext MR_rootSavingContext]];
    
    // Grab the information and validate the data.
    
    NSString *firstName = dict[@"First_name"];
    
    if ([firstName isKindOfClass:[NSString class]]) {
        
        if (!firstName.containsDigits) {
            contact.firstName = firstName;
        }
    }
    
    NSString *lastName = dict[@"last_name"];
    
    if ([lastName isKindOfClass:[NSString class]]) {
        
        if (!lastName.containsDigits) {
            contact.lastName = lastName;
        }
    }
    
    NSString *company = dict[@"company_name"];
    
    if ([company isKindOfClass:[NSString class]]) {
        contact.company = company;
    }
    
    NSString *address = dict[@"address"];
    
    if ([address isKindOfClass:[NSString class]]) {
        contact.address = address;
    }
    
    NSString *city = dict[@"city"];
    
    if ([city isKindOfClass:[NSString class]]) {
        contact.city = city;
    }
    
    NSString *county = dict[@"county"];
    
    if ([county isKindOfClass:[NSString class]]) {
        contact.county = county;
    }
    
    NSString *state = dict[@"state"];
    
    if ([state isKindOfClass:[NSString class]]) {
        contact.state = state;
    }
    
    id zip = dict[@"zip"];
    
    if ([zip isKindOfClass:[NSNumber class]]) {
        NSNumber *zipNumber = (NSNumber *)zip;
        NSString *zipString = zipNumber.stringValue;
        contact.zip = zipString;
    } else if ([zip isKindOfClass:[NSString class]]) {
        contact.zip = zip;
    }
    
    NSString *phone = dict[@"phone1"];
    
    if ([phone isKindOfClass:[NSString class]]) {
        
        if (phone.isValidPhoneNumber) {
            contact.phone = phone;
        }
    }
    
    NSString *altPhone = dict[@"phone2"];
    
    if ([phone isKindOfClass:[NSString class]]) {
        
        if (altPhone.isValidPhoneNumber) {
            contact.alternatePhone = altPhone;
        }
    }
    
    NSString *email = dict[@"email"];
    
    if (email.isValidEmail) {
        contact.email = email;
    }
    
    NSString *web = dict[@"web"];
    
    if (web.isValidURL) {
        contact.website = web;
    }
    
    // Image
    NSString *imageData = dict[@"jpg"];
    
    if (imageData) {
        contact.imageData = imageData;
    }
    
    return contact;
}

- (void)save {
    [[NSManagedObjectContext MR_rootSavingContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

- (void)destroy {
    [self MR_deleteEntity];
    [self save];
}

@end
