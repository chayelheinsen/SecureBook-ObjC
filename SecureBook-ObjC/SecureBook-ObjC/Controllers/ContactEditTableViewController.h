//
//  ContactEditTableViewController.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGContact.h"

@interface ContactEditTableViewController : UITableViewController

@property (weak, nonatomic) PGContact *contact;

@end
