//
//  PGContact.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "PGContact.h"
#import "NSString+Utilities.h"
@import AFNetworking;

@implementation PGContact
@dynamic firstName, lastName, company, address, city, county, state, zip, phone, alternatePhone, email, website, imageData;

#pragma mark - Instance Methods

- (UIImage * _Nullable)profilePicture {
    return [UIImage imageWithData:self.imageData];
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
            
            // Create PGContact's from the array of dictionarys.
            for (NSDictionary *contactDict in contactDicts) {
                // Create the contact.
                PGContact *contact = [PGContact map:contactDict];
                
                // Make sure that we got a contact back and append it to the array.
                if (contact) {
                    [contacts addObject:contact];
                }
            }
            
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
    NSLog(@"%@", dict);
    
    PGContact *contact = [PGContact MR_createEntity];
    
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
    
    NSNumber *zip = dict[@"zip"];
    
    if ([zip isKindOfClass:[NSNumber class]]) {
        contact.zip = zip.integerValue;
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
    NSString *imageString = dict[@"jpg"];
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageString options:0];
    
    if (imageData) {
        contact.imageData = imageData;
    }
    
    return contact;
}

@end
