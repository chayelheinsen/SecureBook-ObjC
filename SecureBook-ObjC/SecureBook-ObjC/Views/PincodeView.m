//
//  PincodeView.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "PincodeView.h"

static const NSUInteger LSPMaxPincodeLength = 4;

@interface PincodeView () {
    NSUInteger _wasCompleted;
}

@property (strong, nonatomic) NSString *pincode;

@end

@implementation PincodeView

- (instancetype)init {
    
    if (self = [super init]) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    self.enabled = YES;
    [self initPincode];
}

- (void)initPincode {
    self.pincode = @"";
}

- (void)setPincode:(NSString *)pincode {
    
    if (_pincode != pincode) {
        _pincode = pincode;
        
        [self setNeedsDisplay];
        
        BOOL length = ([pincode length] == LSPMaxPincodeLength);
        
        if (length && [self.delegate respondsToSelector:@selector(pincodeView:pincode:)]) {
            [self.delegate pincodeView:self pincode:pincode];
        }
    }
}

- (void)appendingPincode:(NSString *)pincode {
    
    if (!self.enabled) {
        return;
    }
    
    NSString * appended = [self.pincode stringByAppendingString:pincode];
    NSUInteger length = MIN([appended length], LSPMaxPincodeLength);
    self.pincode = [appended substringToIndex:length];
}

- (void)removeLastPincode {
    
    if (!self.enabled) {
        return;
    }
    
    NSUInteger index = ([self.pincode length] - 1);
    
    if ([self.pincode length] > index) {
        self.pincode = [self.pincode substringToIndex:index];
    }
}

- (void)wasCompleted {
    
    for (NSUInteger i = 0; i < LSPMaxPincodeLength; i++) {
        dispatch_time_t delayInSeconds = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.01f * NSEC_PER_SEC));
        dispatch_after(delayInSeconds, dispatch_get_main_queue(), ^(void) {
            self->_wasCompleted++;
            [self setNeedsDisplay];
        });
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    [self.pincodeColor setFill];
    
    // 1 character box size
    CGSize boxSize  = CGSizeMake(CGRectGetWidth(rect) / LSPMaxPincodeLength, CGRectGetHeight(rect));
    CGSize charSize = CGSizeMake(13, 13);
    
    CGFloat y = rect.origin.y;
    
    NSUInteger completed = MAX([self.pincode length], _wasCompleted);
    
    // draw a circle : '.'
    NSInteger str = MIN(completed, LSPMaxPincodeLength);
    
    for (NSUInteger idx = 0; idx < str; idx++) {
        CGFloat x = boxSize.width * idx;
        CGRect rounded = CGRectMake(x + floorf((boxSize.width  - charSize.width) / 2),
                                    y + floorf((boxSize.height - charSize.width) / 2),
                                    charSize.width,
                                    charSize.height);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, self.pincodeColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextFillEllipseInRect(context, rounded);
        CGContextFillPath(context);
    }
    
    // draw a dash : '-'
    for (NSUInteger idx = str; idx < LSPMaxPincodeLength; idx++) {
        CGFloat x = boxSize.width * idx;
        CGRect rounded = CGRectMake(x + floorf((boxSize.width  - charSize.width)  / 2),
                                    y + floorf((boxSize.height - charSize.height) / 2),
                                    charSize.width,
                                    charSize.height);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.pincodeColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextAddEllipseInRect(context, rounded);
        CGContextStrokePath(context);
    }
}

@end
