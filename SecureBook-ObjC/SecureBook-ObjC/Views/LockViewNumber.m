//
//  LockViewNumber.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "LockViewNumber.h"

static const CGFloat LSNContextSetLineWidth = 0.8;

@implementation LockViewNumber

- (void)setHighlighted:(BOOL)highlighted {
    
    if (super.highlighted != highlighted) {
        super.highlighted = highlighted;
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat height = CGRectGetHeight(rect);
    CGRect  inset  = CGRectInset(CGRectMake(0, 0, height, height), 1, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef colorRef  = [self tintColor].CGColor;
    UIControlState state = [self state];
    
    CGContextSetLineWidth(context, LSNContextSetLineWidth);
    
    if (state == UIControlStateHighlighted) {
        CGContextSetFillColorWithColor(context, colorRef);
        CGContextFillEllipseInRect (context, inset);
        CGContextFillPath(context);
    } else {
        CGContextSetStrokeColorWithColor(context, colorRef);
        CGContextAddEllipseInRect(context, inset);
        CGContextStrokePath(context);
    }
}

@end
