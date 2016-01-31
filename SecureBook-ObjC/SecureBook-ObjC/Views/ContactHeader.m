//
//  ContactHeader.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "ContactHeader.h"

@interface ContactHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) UIVisualEffectView *blurView;

@end

@implementation ContactHeader

+ (ContactHeader *)initFromNibWithContact:(PGContact *)contact {
    ContactHeader *header = [NSBundle.mainBundle loadNibNamed:@"ContactHeader" owner:nil options:nil].firstObject;
    header.profilePicture.clipsToBounds = YES;
    header.profilePicture.layer.cornerRadius = header.profilePicture.frame.size.height / 2;
    header.profilePicture.image = contact.profilePicture;
    header.background.image = contact.profilePicture;
    [header.background addSubview:header.blurView];
    header.name.text = contact.fullName;
    return header;
}

- (UIVisualEffectView *)blurView {
    
    if (_blurView == nil) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        blurView.translatesAutoresizingMaskIntoConstraints = NO;
        blurView.frame = [UIScreen mainScreen].bounds;
        _blurView = blurView;
    }
    
    return _blurView;
}

@end
