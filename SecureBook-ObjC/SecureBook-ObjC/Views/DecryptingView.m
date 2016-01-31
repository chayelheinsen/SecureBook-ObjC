//
//  DecryptingView.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/30/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "DecryptingView.h"
#import "TouchID.h"

@interface DecryptingView ()

@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) UILabel *decryptMessage;

@end

@implementation DecryptingView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setUpWithTitle:@"Decrypting your contacts..."];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    
    if (self) {
        [self setUpWithTitle:title];
    }
    
    return self;
}

- (void)setUpWithTitle:(NSString *)title {
    // Set up blur view for dycrypting.
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.translatesAutoresizingMaskIntoConstraints = NO;
    blurView.frame = [UIScreen mainScreen].bounds;
    
    self.decryptMessage = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    blurView.frame.size.width,
                                                                    blurView.frame.size.height
                                                                    )];
    
    self.decryptMessage.textColor = [UIColor whiteColor];
    self.decryptMessage.font = [UIFont boldSystemFontOfSize:18];
    self.decryptMessage.textAlignment = NSTextAlignmentCenter;
    self.decryptMessage.text = title;
    [blurView addSubview:self.decryptMessage];
    [self addSubview:blurView];

}

- (void)showOnViewController:(UIViewController *)vc {
    [vc.view addSubview:self];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
