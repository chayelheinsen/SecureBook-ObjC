//
//  PincodeView.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PincodeViewDelegate;

IB_DESIGNABLE
@interface PincodeView : UIView

@property (weak, nonatomic) IBOutlet id<PincodeViewDelegate> delegate;
@property (strong, nonatomic) IBInspectable UIColor *pincodeColor;
@property (nonatomic) IBInspectable BOOL enabled;

- (void)initPincode;
- (void)appendingPincode:(NSString *)pincode;
- (void)removeLastPincode;
- (void)wasCompleted;

@end

@protocol PincodeViewDelegate <NSObject>
@required

- (void)pincodeView:(PincodeView *)pincodeView pincode:(NSString *)pincode;

@end