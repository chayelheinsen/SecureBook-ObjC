//
//  NSData+AES256.h
//  SecureBook-ObjC
//
// https://github.com/rsravan/CoreDataEncryption

@import Foundation;
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "DataGenerator.h"

@interface NSData (AES256)

+ (NSData *)AESKeyForPassword:(NSString *)password salt:(NSData *)salt;
- (NSData *)encryptedDataWithPassword:(NSString *)password iv:(NSData **)iv salt:(NSData **)salt error:(NSError **)error;
- (NSData *)decryptedDataWithPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error;

@end
