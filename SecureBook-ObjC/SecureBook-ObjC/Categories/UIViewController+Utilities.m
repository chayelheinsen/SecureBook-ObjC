//
//  UIViewController+Utilities.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)

- (UIImageView *)removeNavigationBarHairline:(UIView *)underView {
    
    if ([underView isKindOfClass:[UIImageView class]] && underView.bounds.size.height <= 1.0) {
        underView.hidden = YES;
        return (UIImageView *)underView;
    }
    
    for (UIView *subview in underView.subviews) {
        UIImageView *imageView = [self removeNavigationBarHairline:subview];
        
        if (imageView) {
            imageView.hidden = YES;
            return imageView;
        }
    }
    
    return nil;
}

@end
