//
//  RecentContactView.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "RecentContactView.h"

@implementation RecentContactView

- (void)setImage:(UIImage *)image text:(NSString *)text {
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    self.imageView.image = image;
    self.label.text = text;
}

@end
