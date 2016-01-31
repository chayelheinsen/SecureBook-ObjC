//
//  Pin.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "Pin.h"
#import "LockViewController.h"

@interface Pin () <LockViewControllerDelegate, LockViewControllerDataSource>

@property (copy, nonatomic) PinSuccessBlock completion;

@end

@implementation Pin

+ (instancetype)singleton {
    static Pin *singleton = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        singleton = [self new];
    });
    
    return singleton;
}

- (void)setNewPin {
    [self showWithMode:LockScreenModeNew];
}

- (void)showWithCompletion:(PinSuccessBlock)completion {
    [self showWithMode:LockScreenModeNormal];
    self.completion = completion;
}

- (void)showWithMode:(LockScreenMode)mode {
    LockViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([LockViewController class])];
    [viewController setLockScreenMode:mode];
    [viewController setDelegate:self];
    [viewController setDataSource:self];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
}

# pragma mark - LockViewControllerDelegate

- (void)unlockWasSuccessfulLockViewController:(LockViewController *)lockViewController pincode:(NSString *)pincode {
    NSLog(@"Pin %@", pincode);
    
    if (lockViewController.lockScreenMode == LockScreenModeNew) {
        // We want to save this to use for later!
        [CHKeychain setObject:pincode forKey:@"pincode"];
    } else {
        self.completion(YES);
    }
}

- (void)unlockWasSuccessfulLockViewController:(LockViewController *)lockViewController {
    NSLog(@"HERE");
    self.completion(YES);
}

# pragma mark - LockViewControllerDataSource

- (BOOL)lockViewController:(LockViewController *)lockViewController pincode:(NSString *)pincode {
    NSLog(@"entered pin %@", pincode);
    
    NSString *pin = [CHKeychain objectForKey:@"pincode"];
    
    if ([pincode isEqualToString:pin]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)allowTouchIDLockViewController:(LockViewController *)lockViewController {
    return YES;
}

@end
