//
//  DataGenerator.h
//  SecureBook-ObjC
//
// https://github.com/rsravan/CoreDataEncryption

#import <Foundation/Foundation.h>

#define ALL_CHARACTERS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_+={}[]|\\\":;<>?/,.~`'"
#define ALL_CHARACTERS_LENGTH [ALL_CHARACTERS length]

@interface DataGenerator : NSObject

+ (NSString *)createRandomStringOfLength:(int)len;
+ (NSData *)createRandomDataOfLength:(size_t)length;

@end
