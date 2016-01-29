//
//  ContactsTableViewController.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/28/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "PGContact.h"
#import "ContactTableViewCell.h"
#import "RecentContactsTableViewCell.h"
#import "UIViewController+Utilities.h"
#import "PGMacros.h"
@import DGElasticPullToRefresh;

@interface ContactsTableViewController () <UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray<PGContact *> *contacts;
@property (strong, nonatomic) NSMutableArray<PGContact *> *filterdContacts;
@property (strong, nonatomic) UIVisualEffectView *blurView;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contacts = [NSMutableArray new];
    self.filterdContacts = [NSMutableArray new];
    
    // Set up search
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search Contacts";
    self.searchController.searchBar.backgroundColor = self.navigationController.navigationBar.barTintColor;
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    
    // Update the color of the textfield inside the search bar.
    UITextField *searchBarTextField = (UITextField *)[self.searchController.searchBar valueForKey:@"searchField"];
    searchBarTextField.textColor = [UIColor whiteColor];
    
    // Change the search bar placeholder text color
    [searchBarTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.definesPresentationContext = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Setup tableView
    DGElasticPullToRefreshLoadingViewCircle *loadingView = [DGElasticPullToRefreshLoadingViewCircle new];
    loadingView.tintColor = [UIColor whiteColor];
    [self.tableView dg_setPullToRefreshFillColor:self.navigationController.navigationBar.barTintColor];
    [self.tableView dg_setPullToRefreshBackgroundColor:[UIColor whiteColor]];
    
    // Remove that ugly hair line from the navigation bar
    [self removeNavigationBarHairline:self.navigationController.navigationBar];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;

    UIView *footer = [UIView new];
    self.tableView.tableFooterView = footer;
    
    [self.tableView dg_addPullToRefreshWithActionHandler:^{
        [self fetch];
    } loadingView:loadingView];
    
    // blurView is lazy loaded
    [[UIApplication sharedApplication].keyWindow addSubview:self.blurView];
    
    @weakify(self);
    
    // We will fetch and decrypt in the background!
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @strongify(self);
        
        // Fetch and dycrpyt
        // Fetch all the contacts from the store.
        self.contacts = [[PGContact MR_findAllInContext:[NSManagedObjectContext MR_rootSavingContext]] mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the tableView!
            // If there isn't anything persisted, we will fetch it.
            if (self.contacts.count == 0 || !self.contacts) {
                [self fetch];
                [self removeBlurView];
            } else {
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES];
                self.contacts = [[self.contacts sortedArrayUsingDescriptors:@[sort]] mutableCopy];
                [self.tableView reloadData];
                [self removeBlurView];
            }
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        // If we are using the search bar, we want to display the filtered contacts.
        if (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]) {
            return self.filterdContacts.count;
        }
        
        return self.contacts.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        RecentContactsTableViewCell *cell = (RecentContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RecentContactsCell" forIndexPath:indexPath];
        return cell;
    } else {
        ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)c forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        // The recent contacts cell.
        RecentContactsTableViewCell *cell = (RecentContactsTableViewCell *)c;
        
        if ([cell.first.label.text isEqualToString:@""]) {
            [cell randomWithData:self.contacts];
        }
        
    } else {
        // All of the contacts.
        ContactTableViewCell *cell = (ContactTableViewCell *)c;
        PGContact *contact;
        // If we are using the search bar, we want to display the filtered contacts.
        if (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]) {
            contact = [self.filterdContacts objectAtIndex:indexPath.row];
        } else {
            contact = [self.contacts objectAtIndex:indexPath.row];
        }
        
        [cell setDataForContact:contact];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray *letters = [NSMutableArray new];
    
    for (PGContact *contact in self.contacts) {
        NSString *character = [[contact.firstName substringToIndex:1] uppercaseString];
        
        if (![letters containsObject:character]) {
            [letters addObject:character];
        }
    }
    
    return letters; //[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    NSInteger newRow = [self indexForFirstChar:title inArray:self.contacts];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:1];
    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Recent Contacts";
    } else {
        return @"All Contacts";
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForSearchText:searchController.searchBar.text scope:@"All"];
}

#pragma mark - Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    self.filterdContacts = [[self.contacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"fullName contains[c] %@", searchText.lowercaseString]] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Helpers

- (void)fetch {
    [PGContact fetchContactsWithCompletion:^(NSArray<PGContact *> * _Nullable contacts, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            self.contacts = [contacts mutableCopy];
            [self.tableView reloadData];
        }
        
        [self.tableView dg_stopLoading];
    }];
}

// Return the index for the location of the first item in an array that begins with a certain character
- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array {
    NSUInteger count = 0;
    
    for (PGContact *contact in array) {
        
        if ([contact.firstName hasPrefix:character]) {
            return count;
        }
        
        count++;
    }
    
    return 0;
}

- (UIVisualEffectView *)blurView {
    
    if (_blurView == nil) {
        // Set up blur view for dycrypting.
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        blurView.translatesAutoresizingMaskIntoConstraints = NO;
        blurView.frame = [UIScreen mainScreen].bounds;
        
        UILabel *decryptMessage = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            blurView.frame.size.width,
                                                                            blurView.frame.size.height
                                                                            )];
        
        decryptMessage.textColor = [UIColor whiteColor];
        decryptMessage.font = [UIFont boldSystemFontOfSize:18];
        decryptMessage.textAlignment = NSTextAlignmentCenter;
        decryptMessage.text = @"Decrypting your contacts...";
        [blurView addSubview:decryptMessage];
        _blurView = blurView;
    }
    
    return _blurView;
}

- (void)removeBlurView {
    [UIView animateWithDuration:0.5 animations:^{
        self.blurView.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self.blurView removeFromSuperview];
        }
    }];
}

@end
