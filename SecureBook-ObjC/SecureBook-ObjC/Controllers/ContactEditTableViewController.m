//
//  ContactEditTableViewController.m
//  SecureBook-ObjC
//
//  Created by Chayel Heinsen on 1/29/16.
//  Copyright © 2016 Chayel Heinsen. All rights reserved.
//

#import "ContactEditTableViewController.h"
#import "ContactHeader.h"
#import "NSString+Utilities.h"
@import MXParallaxHeader;
@import ionicons;
@import Mercury;

@interface ContactEditTableViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *firstNameImage;
@property (strong, nonatomic) IBOutlet UIImageView *lastNameImage;
@property (strong, nonatomic) IBOutlet UIImageView *emailImage;
@property (strong, nonatomic) IBOutlet UIImageView *phoneImage;
@property (strong, nonatomic) IBOutlet UIImageView *addressImage;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *addressField;

@end

@implementation ContactEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = edit;
    
    // Parallax Header
    self.tableView.parallaxHeader.view = [ContactHeader initFromNibWithContact:self.contact];
    self.tableView.parallaxHeader.height = 300;
    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.tableView.parallaxHeader.minimumHeight = 20;
    
    UIView *footer = [UIView new];
    self.tableView.tableFooterView = footer;
    
    self.title = @"Edit Contact";
    
    [self setFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.firstNameField becomeFirstResponder];
            break;
        case 1:
            [self.lastNameField becomeFirstResponder];
            break;
        case 2:
            [self.emailField becomeFirstResponder];
            break;
        case 3:
            [self.phoneField becomeFirstResponder];
            break;
        case 4:
            [self.addressField becomeFirstResponder];
            break;
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helpers

- (void)save {
    
    Mercury *mercury = [Mercury sharedInstance];
    [mercury wait];
    
    if (![[self.firstNameField.text removeWhitespace] containsDigits]) {
        self.contact.firstName = [self.firstNameField.text removeWhitespace];
    } else {
        MercuryNotification *error = [MercuryNotification new];
        error.text = @"Couldn't save first name. Please try again.";
        error.color = [UIColor redColor];
        [mercury postNotification:error];
    }
    
    if (![[self.lastNameField.text removeWhitespace] containsDigits]) {
        self.contact.lastName = [self.lastNameField.text removeWhitespace];
    } else {
        MercuryNotification *error = [MercuryNotification new];
        error.text = @"Couldn't save last name. Please try again.";
        error.color = [UIColor redColor];
        [mercury postNotification:error];
    }
    
    if ([[self.emailField.text removeWhitespace] isValidEmail]) {
        self.contact.email = [self.emailField.text removeWhitespace];
    } else {
        MercuryNotification *error = [MercuryNotification new];
        error.text = @"Couldn't save email. Please try again.";
        error.color = [UIColor redColor];
        [mercury postNotification:error];
    }
    
    if ([[self.phoneField.text removeWhitespace] isValidPhoneNumber]) {
        self.contact.phone = [self.phoneField.text removeWhitespace];
    } else {
        MercuryNotification *error = [MercuryNotification new];
        error.text = @"Couldn't save phone number. Please try again.";
        error.color = [UIColor redColor];
        [mercury postNotification:error];
    }
    
    self.contact.address = self.addressField.text;
    
    [self.contact save];
    
    [mercury go];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFields {
    self.firstNameImage.image = [IonIcons imageWithIcon:ion_person size:50 color:[UIColor grayColor]];
    self.firstNameField.text = self.contact.firstName;
    self.lastNameImage.image = [IonIcons imageWithIcon:ion_person size:50 color:[UIColor grayColor]];
    self.lastNameField.text = self.contact.lastName;
    self.emailImage.image = [IonIcons imageWithIcon:ion_ios_email_outline size:50 color:[UIColor grayColor]];
    self.emailField.text = self.contact.email;
    self.phoneImage.image = [IonIcons imageWithIcon:ion_ios_telephone_outline size:50 color:[UIColor grayColor]];
    self.phoneField.text = self.contact.phone;
    self.addressImage.image = [IonIcons imageWithIcon:ion_ios_home_outline size:50 color:[UIColor grayColor]];
    self.addressField.text = self.contact.address;
}

@end
