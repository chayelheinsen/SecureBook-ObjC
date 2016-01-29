//
//  ContactHeader.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGContact.h"

@interface ContactHeader : UIView

+ (ContactHeader *)initFromNibWithContact:(PGContact *)contact;

@end
