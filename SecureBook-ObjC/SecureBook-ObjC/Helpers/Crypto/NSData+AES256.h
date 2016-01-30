//
//  NSData+AES256.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

@import Foundation;
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "DataGenerator.h"

@interface NSData (AES256)

+ (NSData *)AESKeyForPassword:(NSString *)password salt:(NSData *)salt;
- (NSData *)encryptedDataWithPassword:(NSString *)password iv:(NSData **)iv salt:(NSData **)salt error:(NSError **)error;
- (NSData *)decryptedDataWithPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error;

@end
