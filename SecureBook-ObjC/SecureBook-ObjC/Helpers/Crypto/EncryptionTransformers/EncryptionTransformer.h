//
//  EncryptedTransformer.h
//  SecureBook-ObjC
//
// https://github.com/rsravan/CoreDataEncryption

#import "NSData+AES256.h"
#include <stdlib.h>
#import "KeychainItemWrapper.h"
#import "DataGenerator.h"

@interface EncryptionTransformer : NSValueTransformer

/**
 * Returns the key used for encrypting / decrypting values during transformation.
 */
- (NSString *)key;

@end