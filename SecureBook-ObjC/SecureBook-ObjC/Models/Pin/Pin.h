//
//  Pin.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHKeychain.h"

typedef void (^PinSuccessBlock)(BOOL success);

@interface Pin : NSObject

+ (instancetype)singleton;
- (void)setNewPin;
- (void)showWithCompletion:(PinSuccessBlock)completion;

@end
