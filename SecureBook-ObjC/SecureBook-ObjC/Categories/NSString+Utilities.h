//
//  NSString+Utilities.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

/**
 *  @return YES if the string contains digits, otherwise, NO.
 */
- (BOOL)containsDigits;

/**
 *  @return YES if the string is a valid email, otherwise, NO.
 */
- (BOOL)isValidEmail;

/**
 *  @return YES if the string is a valid phone number, otherwise, NO.
 */
- (BOOL)isValidPhoneNumber;

/**
 *  @return YES if the string is a valid url, otherwise, NO.
 */
- (BOOL)isValidURL;

/**
 *  Removes leading and trailing whitespace.
 *  @return A new string.
 */
- (NSString *)removeWhitespace;

@end
