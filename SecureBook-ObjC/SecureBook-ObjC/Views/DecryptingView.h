//
//  DecryptingView.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecryptingView : UIView

- (instancetype)initWithTitle:(NSString *)title;
- (void)showOnViewController:(UIViewController *)vc;
- (void)show;
- (void)hide;

@end
