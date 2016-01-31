//
//  RecentContactsTableViewCell.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "RecentContactsTableViewCell.h"
#import "PGContact.h"

@implementation RecentContactsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)randomWithData:(NSArray *)contacts {
    
    // In the first section, we want to emulate that recent contacts.
    // Every reaload of the data will produce a 'new' random recent 4.
    NSMutableArray<NSNumber *> *randoms = [NSMutableArray new];

    if (contacts.count >= 4) {
        while (randoms.count < 4) {
            NSUInteger r = arc4random_uniform((uint32_t)contacts.count);

            if (![randoms containsObject:[NSNumber numberWithUnsignedInteger:r]]) {
                [randoms addObject:[NSNumber numberWithUnsignedInteger:r]];
            }
        }
    } else {
        while (randoms.count < contacts.count) {
            NSUInteger r = arc4random_uniform((uint32_t)contacts.count);

            if (![randoms containsObject:[NSNumber numberWithUnsignedInteger:r]]) {
                [randoms addObject:[NSNumber numberWithUnsignedInteger:r]];
            }
        }
    }

    if (contacts.count >= 1) {
        PGContact *contact = [contacts objectAtIndex:randoms[0].unsignedIntegerValue];

        if (contact.profilePicture) {
            [self.first setImage:contact.profilePicture text:contact.firstName];
        }
    }

    if (contacts.count >= 2) {
        PGContact *contact = [contacts objectAtIndex:randoms[1].unsignedIntegerValue];

        if (contact.profilePicture) {
            [self.second setImage:contact.profilePicture text:contact.firstName];
        }
    }

    if (contacts.count >= 3) {
        PGContact *contact = [contacts objectAtIndex:randoms[2].unsignedIntegerValue];

        if (contact.profilePicture) {
            [self.third setImage:contact.profilePicture text:contact.firstName];
        }
    }

    if (contacts.count >= 4) {
        PGContact *contact = [contacts objectAtIndex:randoms[3].unsignedIntegerValue];

        if (contact.profilePicture) {
            [self.fourth setImage:contact.profilePicture text:contact.firstName];
        }
    }
}


@end
