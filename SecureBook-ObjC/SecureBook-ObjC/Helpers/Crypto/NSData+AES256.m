//
//  NSData+AES256.m
//  SecureBook-ObjC
//
// https://github.com/rsravan/CoreDataEncryption

#import "NSData+AES256.h"

@implementation NSData (AES256)

NSString * const kRNCryptManagerErrorDomain = @"com.chayelheinsen.SecureBook";

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;

// Borrowed some code from http://robnapier.net/aes-commoncrypto/

+ (NSData *)AESKeyForPassword:(NSString *)password salt:(NSData *)salt {
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
    
    int
    result __unused = CCKeyDerivationPBKDF(kCCPBKDF2,       // algorithm
                                  password.UTF8String,      // password
                                  [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding],  // passwordLength
                                  salt.bytes,               // salt
                                  salt.length,              // saltLen
                                  kCCPRFHmacAlgSHA1,        // PRF
                                  kPBKDFRounds,             // rounds
                                  derivedKey.mutableBytes,  // derivedKey
                                  derivedKey.length);       // derivedKeyLen
    
    // Do not log password here
    NSAssert(result == kCCSuccess, @"Unable to create AES key for password: %d", result);
    
    return derivedKey;
}

- (NSData *)encryptedDataWithPassword:(NSString *)password iv:(NSData **)iv salt:(NSData **)salt error:(NSError **)error {
    
    NSAssert(iv, @"IV must not be NULL");
    NSAssert(salt, @"salt must not be NULL");
    
    *iv = [DataGenerator createRandomDataOfLength:kAlgorithmIVSize];
    *salt = [DataGenerator createRandomDataOfLength:kPBKDFSaltSize];
    
    NSData *key = [NSData AESKeyForPassword:password salt:*salt];
    
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData dataWithLength:self.length + kAlgorithmBlockSize];
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, // operation
                     kAlgorithm, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     key.length, // keylength
                     (*iv).bytes,// iv
                     self.bytes, // dataIn
                     self.length, // dataInLength,
                     cipherData.mutableBytes, // dataOut
                     cipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    } else {
        
        if (error) {
            *error = [NSError errorWithDomain:kRNCryptManagerErrorDomain code:result userInfo:nil];
        }
        
        return nil;
    }
    
    return cipherData;
}

- (NSData *)decryptedDataWithPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error {
    
    NSData *key = [NSData AESKeyForPassword:password salt:salt];
    
    size_t outLength;
    NSMutableData * decryptedData = [NSMutableData dataWithLength:self.length];
    CCCryptorStatus result = CCCrypt(kCCDecrypt, // operation
                     kAlgorithm, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     key.length, // keylength
                     iv.bytes,// iv
                     self.bytes, // dataIn
                     self.length, // dataInLength,
                     decryptedData.mutableBytes, // dataOut
                     decryptedData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        [decryptedData setLength:outLength];
    } else {
        
        if (result != kCCSuccess) {
          
            if (error) {
                *error = [NSError errorWithDomain:kRNCryptManagerErrorDomain code:result userInfo:nil];
            }
            
            return nil;
        }
    }
    
    return decryptedData;
}

@end
