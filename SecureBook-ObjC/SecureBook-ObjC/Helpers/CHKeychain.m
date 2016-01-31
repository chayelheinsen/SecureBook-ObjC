//
//  Keychain.m
//  Chayel Heinsen API
//
//  Created by Chayel Heinsen on 7/25/14.
//  Copyright © 2014 Chayel Heinsen. All rights reserved.
//

#import "CHKeychain.h"

#define CHECK_OSSTATUS_ERROR(x) (x == noErr) ? YES : NO

@interface CHKeychain ()

/**
 *  Queries the Keychain.
 *
 *  @param key The key to query for.
 *
 *  @return The Keychain.
 */
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key;

@end

@implementation CHKeychain

#pragma mark - Public Methods

+ (BOOL)setObject:(id)value forKey:(NSString*)key {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    // Delete any previous value with this key
    // We could use SecItemUpdate but its unnecesarily more complicated
    [self removeObjectForKey:key];
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:(__bridge id)kSecValueData];
    
    OSStatus result = SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    
    return CHECK_OSSTATUS_ERROR(result);
}

+ (BOOL)removeObjectForKey:(NSString *)key {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    return CHECK_OSSTATUS_ERROR(result);
}

+ (id)objectForKey:(NSString *)key {
    
    id value = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    CFDataRef keyData = NULL;
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        
        @try {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
            value = nil;
        }
        @finally {}
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return value;
}

#pragma mark - Private Methods

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    
    return [@{(__bridge id)kSecClass            : (__bridge id)kSecClassGenericPassword,
              (__bridge id)kSecAttrService      : key,
              (__bridge id)kSecAttrAccount      : key,
              (__bridge id)kSecAttrAccessible   : (__bridge id)kSecAttrAccessibleAfterFirstUnlock
              } mutableCopy];
}

@end