//
//  InboxViewController.m
//  Ribbit
//
//  Created by Michael Liquori on 10/6/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import "InboxViewController.h"
#import "ImageViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else {
        NSLog(@"Current user: %@", currentUser.username);
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //Query to get messages intended for the Current User
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];

    // Order by descending creation date/time
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            //We found messages!
            self.messages = objects;
            [self.tableView reloadData];
//            NSLog(@"Retrieved %lu messages",(unsigned long)[self.messages count]);
        }
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.messages count];
}

//Populates the cells of the table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //Identifies the cells and cycles through them for memory purposes
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    //Populate cells with messages from Parse, labeled by senderName
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];

    //Check fileType for icon display
    NSString *fileType = [message objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    return cell;
}

//What happens when a row is selected:

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //I think the bad behavior is that it does not determine the image type until the first click?
    
    //access the message so we can later determine if its video or image
    //PFObject *message = [self.messages objectAtIndex:indexPath.row];
    
    //set the selected cell as selectedMessage variable (property)
    self.selectedMessage  = [self.messages objectAtIndex:indexPath.row];
    //check the fileType and save it to fileType variable.
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // This is what happens when certain outlets are triggered from Main.storyboard
    
    //When logout button is clicked
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    //When an image will be shown
    else if ([segue.identifier isEqualToString:@"showImage"]) {
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
        /* Non-Fix idea
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        ImageViewController *controller = (ImageViewController *)navController.topViewController;
        controller.message = self.selectedMessage;
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        */
        /* Original
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
         */
//    }

}

#pragma mark - Helper Methods

- (IBAction)logout:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [PFUser logOut];
    }
    else {
        
    }
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

@end
