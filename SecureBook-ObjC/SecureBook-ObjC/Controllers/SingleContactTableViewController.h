//
//  SingleContactTableViewController.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGContact.h"

@interface SingleContactTableViewController : UITableViewController

@property (weak, nonatomic) PGContact *contact;

@end
