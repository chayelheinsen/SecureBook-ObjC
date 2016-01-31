//
//  TouchID.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "TouchID.h"
@import LocalAuthentication;
@import Mercury;

@implementation TouchID

+ (BOOL)canShowTouchID {
    LAContext *context = [LAContext new];
    return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
}

+ (void)showWithReason:(NSString * _Nonnull)reason completion:(void(^ _Nonnull)(BOOL success))completion {
    LAContext *context = [LAContext new];
    NSError *authError = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:reason
                            reply:^(BOOL success, NSError *error) {
                                
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        completion(YES);
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        completion(NO);
                                    });
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(NO);
        });
    }
}

@end
