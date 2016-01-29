//
//  SingleContactTableViewController.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "SingleContactTableViewController.h"
#import "ContactHeader.h"
#import "ContactInformationTableViewCell.h"
#import "ContactEditTableViewController.h"
@import MXParallaxHeader;
@import ionicons;

@interface SingleContactTableViewController ()

@end

@implementation SingleContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithImage:[IonIcons imageWithIcon:ion_edit size:25 color:self.navigationController.navigationBar.tintColor] style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = edit;
    
    // Parallax Header
    self.tableView.parallaxHeader.view = [ContactHeader initFromNibWithContact:self.contact];
    self.tableView.parallaxHeader.height = 300;
    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.tableView.parallaxHeader.minimumHeight = 20;
    
    UIView *footer = [UIView new];
    self.tableView.tableFooterView = footer;
    
    self.title = self.contact.firstName;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)c forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactInformationTableViewCell *cell = (ContactInformationTableViewCell *)c;
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [IonIcons imageWithIcon:ion_ios_email_outline size:50 color:[UIColor grayColor]];
            cell.information.text = self.contact.email;
            break;
        case 1:
            cell.imageView.image = [IonIcons imageWithIcon:ion_ios_telephone_outline size:50 color:[UIColor grayColor]];
            cell.information.text = self.contact.phone;
            break;
        case 2:
            cell.imageView.image = [IonIcons imageWithIcon:ion_ios_home size:50 color:[UIColor grayColor]];
            cell.information.text = self.contact.address;
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([[segue destinationViewController] isKindOfClass:[ContactEditTableViewController class]]) {
        ContactEditTableViewController *vc = (ContactEditTableViewController *)[segue destinationViewController];
        vc.contact = (PGContact *)sender;
    }
}

#pragma mark - Helpers

- (void)edit {
    [self performSegueWithIdentifier:@"EditContactTableViewControllerSegue" sender:self.contact];
}

@end
