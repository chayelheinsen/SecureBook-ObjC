//
//  RecentContactsTableViewCell.h
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

@import UIKit;
#import "RecentContactView.h"

@interface RecentContactsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) IBOutlet RecentContactView *first;
@property (strong, nonatomic) IBOutlet RecentContactView *second;
@property (strong, nonatomic) IBOutlet RecentContactView *third;
@property (strong, nonatomic) IBOutlet RecentContactView *fourth;

- (void)randomWithData:(NSArray *)contacts;

@end
