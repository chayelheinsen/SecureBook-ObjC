//
//  CHKeychain.h
//  Chayel Heinsen API
//
//  Created by Chayel Heinsen on 7/25/14.
//  Copyright © 2014 Chayel Heinsen. All rights reserved.
//

@import Foundation;
@import Security;

@interface CHKeychain : NSObject

/**
 *  Saves an object into the Keychain.
 *
 *  @param value The object to save.
 *  @param key   The key indentifing the value.
 *
 *  @return Yes if saved successfully, otherwise NO.
 */
+ (BOOL)setObject:(id)value forKey:(NSString*)key;

/**
 *  Removes an object from the Keychain.
 *
 *  @param key The key indentifing the value.
 *
 *  @return YES if deleted successfully, otherwise NO if object was not found or an error occured.
 */
+ (BOOL)removeObjectForKey:(NSString *)key;

/**
 @abstract Loads a given value from the Keychain
 @param key The key identifying the value you want to load.
 @return The value identified by key or nil if it doesn't exist.
 */
/**
 *  Gets an object from the Keychain.
 *
 *  @param key The key identifying the object you want.
 *
 *  @return The object indentified by the key or nil if the object could't be found.
 */
+ (id)objectForKey:(NSString*)key;

@end