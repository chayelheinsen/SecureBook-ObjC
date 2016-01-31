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
#import "SingleContactTableViewController.h"
#import "PGMacros.h"
#import "DecryptingView.h"
#import "LockViewController.h"
#import "Pin.h"

@import DGElasticPullToRefresh;

@interface ContactsTableViewController () <UISearchControllerDelegate, UISearchResultsUpdating>

// Lazy loaded!
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray<PGContact *> *contacts;
@property (strong, nonatomic) NSMutableArray<PGContact *> *filterdContacts;
@property (strong, nonatomic) DecryptingView *decryptView;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contacts = [NSMutableArray new];
    self.filterdContacts = [NSMutableArray new];
    
    // Setup tableView
    DGElasticPullToRefreshLoadingViewCircle *loadingView = [DGElasticPullToRefreshLoadingViewCircle new];
    loadingView.tintColor = [UIColor whiteColor];
    [self.tableView dg_setPullToRefreshFillColor:self.navigationController.navigationBar.barTintColor];
    [self.tableView dg_setPullToRefreshBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.sectionIndexBackgroundColor = self.navigationController.navigationBar.barTintColor;
    
    // Remove that ugly hair line from the navigation bar
    [self removeNavigationBarHairline:self.navigationController.navigationBar];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;

    UIView *footer = [UIView new];
    self.tableView.tableFooterView = footer;
    
    [self.tableView dg_addPullToRefreshWithActionHandler:^{
        [self fetch];
    } loadingView:loadingView];
    
    NSString *pin = [CHKeychain objectForKey:@"pincode"];
    
    self.decryptView = [DecryptingView new];
    [self.decryptView showOnViewController:self.navigationController];
    
    if (pin == nil) {
        // First Run
        // Lets set up a pin!
        Pin *pin = [Pin singleton];
        [pin setNewPin];
        [self decryptData];
    } else {
        Pin *pin = [Pin singleton];
        
        [pin showWithCompletion:^(BOOL success) {
            [self decryptData];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // We reload to update the data because
    // the data could change if the user edits a contact.
    [self.tableView reloadData];
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
    
    if (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]) {
        return nil;
    } else {
        NSMutableArray *letters = [NSMutableArray new];
        
        for (PGContact *contact in self.contacts) {
            NSString *character = [[contact.firstName substringToIndex:1] uppercaseString];
            
            if (![letters containsObject:character]) {
                [letters addObject:character];
            }
        }
        
        return letters; //[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
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
    
    if (indexPath.section == 1) {
        PGContact *contact;
        
        if (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]) {
            contact = [self.filterdContacts objectAtIndex:indexPath.row];
        } else {
            contact = [self.contacts objectAtIndex:indexPath.row];
        }
        
        [self performSegueWithIdentifier:@"SingleContactTableViewControllerSegue" sender:contact];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[SingleContactTableViewController class]]) {
        SingleContactTableViewController *vc = (SingleContactTableViewController *)[segue destinationViewController];
        vc.contact = (PGContact *)sender;
    }
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
    [self fetchWithCompletion:nil];
}

- (void)fetchWithCompletion:(void(^)())completion {
    [PGContact fetchContactsWithCompletion:^(NSArray<PGContact *> * _Nullable contacts, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            self.contacts = [contacts mutableCopy];
            [self.tableView reloadData];
        }
        
        [self.tableView dg_stopLoading];
        
        if (completion) {
            completion();
        }
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

- (UISearchController *)searchController {
    
    if (_searchController == nil) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = NO;
        searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchController.hidesNavigationBarDuringPresentation = NO;
        searchController.searchBar.placeholder = @"Search Contacts";
        searchController.searchBar.backgroundColor = self.navigationController.navigationBar.barTintColor;
        searchController.searchBar.barTintColor = [UIColor whiteColor];
        searchController.searchBar.tintColor = [UIColor whiteColor];
        self.definesPresentationContext = YES;
        
        // Update the color of the textfield inside the search bar.
        UITextField *searchBarTextField = (UITextField *)[searchController.searchBar valueForKey:@"searchField"];
        searchBarTextField.textColor = [UIColor whiteColor];
        
        // Change the search bar placeholder text color
        [searchBarTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchController = searchController;
    }
    
    return _searchController;
}

- (void)decryptData {
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
                [self fetchWithCompletion:^{
                    [self.decryptView hide];
                }];
            } else {
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES];
                self.contacts = [[self.contacts sortedArrayUsingDescriptors:@[sort]] mutableCopy];
                [self.tableView reloadData];
                [self.decryptView hide];
            }
        });
    });
}

@end
