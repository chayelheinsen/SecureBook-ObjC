//
//  LockViewController.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "LockViewController.h"
#import "PincodeView.h"
#import "TouchID.h"
#import "PGMacros.h"

@import AudioToolbox;

static const NSTimeInterval LVSwipeAnimationDuration = 0.3;
static const NSTimeInterval LVDismissWaitingDuration = 0.4;
static const NSTimeInterval LVShakeAnimationDuration = 0.5;

@interface LockViewController ()<PincodeViewDelegate> {
    NSString *_confirmPincode;
    LockScreenMode _prevLockScreenMode;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet PincodeView *pincodeView;

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.lockScreenMode) {
        case LockScreenModeVerification:
        case LockScreenModeNormal: {
            [self updateTitle:@"Enter Pincode" subtitle:@""];
            [self.cancelButton setHidden:YES];
            break;
        }
        case LockScreenModeNew: {
            [self updateTitle:@"New Pincode" subtitle:@""];
            [self.cancelButton setHidden:YES];
            break;
        }
        case LockScreenModeChange: {
            [self updateTitle:@"Change Pincode" subtitle:@""];
            break;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    BOOL isModeNormal = (self.lockScreenMode == LockScreenModeNormal);
    
    if (isModeNormal && [self.delegate respondsToSelector:@selector(allowTouchIDLockViewController:)]) {
    
        if ([self.dataSource allowTouchIDLockViewController:self]) {
            [self policyDeviceOwnerAuthentication];
        }
    }
}

- (void)policyDeviceOwnerAuthentication {
    
    [TouchID showWithReason:@"Authenticate to decrypt contacts" completion:^(BOOL success) {
        
        if (success) {
            [self unlockDelayDismissViewController:LVDismissWaitingDuration];
        }
    }];
}

- (void)unlockDelayDismissViewController:(NSTimeInterval)delay {
    @weakify(self);
    
    [self.pincodeView wasCompleted];
    
    dispatch_time_t delayInSeconds = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(delayInSeconds, dispatch_get_main_queue(), ^(void) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            
            if ([self.delegate respondsToSelector:@selector(unlockWasSuccessfulLockViewController:)]) {
                [self.delegate unlockWasSuccessfulLockViewController:self];
            }
        }];
    });
}

- (BOOL)isPincodeValid:(NSString *)pincode {

    if (self.lockScreenMode == LockScreenModeVerification) {
        return [_confirmPincode isEqualToString:pincode];
    }
    
    return [self.dataSource lockViewController:self pincode:pincode];
}

- (void)updateTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self.titleLabel setText:title];
    [self.subtitleLabel setText:subtitle];
}

- (void)unlockScreenSuccessful:(NSString *)pincode {
    [self dismissViewControllerAnimated:NO completion:^{
        
        if ([self.delegate respondsToSelector:@selector(unlockWasSuccessfulLockViewController:pincode:)]) {
            [self.delegate unlockWasSuccessfulLockViewController:self pincode:pincode];
        }
    }];
}

- (void)unlockScreenFailure {
    
    if (self.lockScreenMode != LockScreenModeVerification) {
        
        if ([self.delegate respondsToSelector:@selector(unlockWasFailureLockViewController:)]) {
            [self.delegate unlockWasFailureLockViewController:self];
        }
    }
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    // make shake animation
    CAAnimation *shake = [self lsv_makeShakeAnimation];
    [self.pincodeView.layer addAnimation:shake forKey:@"shake"];
    [self.pincodeView setEnabled:NO];
    [self.subtitleLabel setText:@"Pincode did not match"];
    
    dispatch_time_t delayInSeconds = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LVShakeAnimationDuration * NSEC_PER_SEC));
    dispatch_after(delayInSeconds, dispatch_get_main_queue(), ^(void){
        [self.pincodeView setEnabled:YES];
        [self.pincodeView initPincode];
        
        switch (self.lockScreenMode) {
            case LockScreenModeNormal: {
                [self updateTitle:@"Enter Pincode" subtitle:@""];
                break;
            }
            case LockScreenModeNew: {
                [self updateTitle:@"New Pincode" subtitle:@""];
                break;
            }
            case LockScreenModeChange: {
                [self updateTitle:@"Change Pincode" subtitle:@""];
                break;
            }
                
            default:
                break;
        }
    });
}

- (CAAnimation *)lsv_makeShakeAnimation {
    CAKeyframeAnimation * shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    [shake setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [shake setDuration:LVShakeAnimationDuration];
    [shake setValues:@[ @(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0) ]];
    
    return shake;
}

- (void)lsv_swipeSubtitleAndPincodeView {
    
    __weak UIView *weakView = self.view;
    __weak UIView *weakCode = self.pincodeView;
    
    [(id)weakCode setEnabled:NO];
    
    CGFloat width = CGRectGetWidth([self view].bounds);
    NSLayoutConstraint *centerX = [self findLayoutConstraint:weakView  childView:self.subtitleLabel attribute:NSLayoutAttributeCenterX];
    
    centerX.constant = width;
    [UIView animateWithDuration:LVSwipeAnimationDuration animations:^{
        [weakView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [(id)weakCode initPincode];
        centerX.constant = -width;
        [weakView layoutIfNeeded];
        
        centerX.constant = 0;
        [UIView animateWithDuration:LVSwipeAnimationDuration animations:^{
            [weakView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [(id)weakCode setEnabled:YES];
        }];
    }];
}

#pragma mark - NSLayoutConstraint

- (NSLayoutConstraint *)findLayoutConstraint:(UIView *)superview childView:(UIView *)childView attribute:(NSLayoutAttribute)attribute {
    
    for (NSLayoutConstraint * constraint in superview.constraints) {
        
        if (constraint.firstItem == superview && constraint.secondItem == childView && constraint.firstAttribute == attribute) {
            return constraint;
        }
    }
    
    return nil;
}

#pragma mark - IBAction

- (IBAction)onNumberClicked:(id)sender {
    NSInteger number = [sender tag];
    [self.pincodeView appendingPincode:[@(number) description]];
}

- (IBAction)onCancelClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(unlockWasCancelledLockViewController:)]) {
        [self.delegate unlockWasCancelledLockViewController:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onDeleteClicked:(id)sender {
    [self.pincodeView removeLastPincode];
}

#pragma mark - PincodeViewDelegate

- (void)pincodeView:(PincodeView *)lockScreenPincodeView pincode:(NSString *)pincode {
    
    if (self.lockScreenMode == LockScreenModeNormal) {

        if ([self isPincodeValid:pincode]) {
            [self unlockScreenSuccessful:pincode];
        } else {
            [self unlockScreenFailure];
        }
    } else if (self.lockScreenMode == LockScreenModeVerification) {

        if ([self isPincodeValid:pincode]) {
            [self setLockScreenMode:_prevLockScreenMode];
            [self unlockScreenSuccessful:pincode];
        } else {
            [self setLockScreenMode:_prevLockScreenMode];
            [self unlockScreenFailure];
        }
    } else {
        _confirmPincode = pincode;
        _prevLockScreenMode = self.lockScreenMode;
        [self setLockScreenMode:LockScreenModeVerification];
        
        [self updateTitle:@"Confirm Pin" subtitle:@""];
        
        [self lsv_swipeSubtitleAndPincodeView];
    }
}

#pragma mark - LockViewController Orientation

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
