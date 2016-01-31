//
//  LockViewController.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LockScreenMode) {
    LockScreenModeNormal = 0,
    LockScreenModeNew,
    LockScreenModeChange,
    LockScreenModeVerification
};

@protocol LockViewControllerDelegate;
@protocol LockViewControllerDataSource;

@interface LockViewController : UIViewController

@property (unsafe_unretained, nonatomic) LockScreenMode lockScreenMode;
@property (weak, nonatomic) id<LockViewControllerDelegate> delegate;
@property (weak, nonatomic) id<LockViewControllerDataSource> dataSource;

@end

@protocol LockViewControllerDelegate <NSObject>

@optional
- (void)unlockWasSuccessfulLockViewController:(LockViewController *)lockViewController pincode:(NSString *)pincode;
- (void)unlockWasSuccessfulLockViewController:(LockViewController *)lockViewController;
- (void)unlockWasCancelledLockViewController:(LockViewController *)lockViewController;
- (void)unlockWasFailureLockViewController:(LockViewController *)lockViewController;

@end

@protocol LockViewControllerDataSource <NSObject>

@required
- (BOOL)lockViewController:(LockViewController *)lockViewController pincode:(NSString *)pincode;

@optional
- (BOOL)allowTouchIDLockViewController:(LockViewController *)lockViewController;

@end
