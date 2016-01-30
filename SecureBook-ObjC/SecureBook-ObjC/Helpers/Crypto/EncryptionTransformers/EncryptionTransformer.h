//
//  EncryptedTransformer.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

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