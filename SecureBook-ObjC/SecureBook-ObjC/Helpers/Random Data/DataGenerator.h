//
//  DataGenerator.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALL_CHARACTERS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_+={}[]|\\\":;<>?/,.~`'"
#define ALL_CHARACTERS_LENGTH [ALL_CHARACTERS length]

@interface DataGenerator : NSObject

+ (NSString *)createRandomStringOfLength:(int)len;
+ (NSData *)createRandomDataOfLength:(size_t)length;

@end
