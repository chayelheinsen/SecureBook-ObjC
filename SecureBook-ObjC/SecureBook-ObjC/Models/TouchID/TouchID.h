//
//  TouchID.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchID : NSObject

+ (BOOL)canShowTouchID;
+ (void)showWithReason:(NSString * _Nonnull)reason completion:(void(^ _Nonnull)(BOOL success))completion;

@end
