//
//  ContactInformationTableViewCell.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGContact.h"

@interface ContactInformationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *information;

//- (void)setDataForContact:(PGContact *)contact;

@end
