//
//  ContactTableViewCell.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "CDFInitialsAvatar.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataForContact:(PGContact *)contact {
    // To make the imageview round.
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height / 2;
    
    if (contact.profilePicture) {
        self.profilePicture.image = contact.profilePicture;
    }
    
    self.name.text = contact.fullName;
}

@end
