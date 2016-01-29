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
@import MXParallaxHeader;
@import ionicons;

@interface SingleContactTableViewController ()

@end

@implementation SingleContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Parallax Header
    self.tableView.parallaxHeader.view = [ContactHeader initFromNibWithContact:self.contact];
    self.tableView.parallaxHeader.height = 300;
    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.tableView.parallaxHeader.minimumHeight = 20;
    
    UIView *footer = [UIView new];
    self.tableView.tableFooterView = footer;
}

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

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 20;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
