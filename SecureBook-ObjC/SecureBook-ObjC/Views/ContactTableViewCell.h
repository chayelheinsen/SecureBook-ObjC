//
//  ContactTableViewCell.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGContact.h"

@interface ContactTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *name;

- (void)setDataForContact:(PGContact *)contact;

@end
