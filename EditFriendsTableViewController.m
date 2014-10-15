//
//  EditFriendsTableViewController.m
//  Ribbit
//
//  Created by Michael Liquori on 10/14/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import "EditFriendsTableViewController.h"
//#import <Parse/Parse.h>

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFUser query]; //     PFQuery *query = [PFQuery queryWithClassName:@"Apps"];

    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            self.allUsers = objects; //self.apps = objects;
            NSLog(@"%@", self.allUsers);
            [self.tableView reloadData];
        }
    }];
    
    self.currentUser = [PFUser currentUser];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.allUsers count];
}

// Draw cells based on who is already friends.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self isFriend:user]) { //if user is a friend
        cell.accessoryType = UITableViewCellAccessoryCheckmark;//add checkmark
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone; //clear checkmark
    }
    
    return cell;
}

#pragma mark - Table Navigation
//When User Taps on a Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //as it loops put each user into user variable, put relation into relation variable
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    if ([self isFriend:user]) { //if user tapped is a friend already, REMOVE them
        
        // 1. remove checkmark
            cell.accessoryType = UITableViewCellAccessoryNone;

        // 2. remove from array of friends
            for (PFUser *friend in self.friends) { // Loop through local array to find that friend
                if ([friend.objectId isEqualToString:user.objectId]) {
                    [self.friends removeObject:friend];
                    break; // exit loop
                }
            }

        // 3. remove from backend (parse.com)
            [friendsRelation removeObject:user];
    }
    else{ //if not a friend already, ADD them
        
        // 1. Add Checkmark
            cell.accessoryType = UITableViewCellAccessoryCheckmark;

        // 2. add to array of friends
            PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
            [self.friends addObject:user]; //add to local array

        // 3. Add to Parse.com backend
            [friendsRelation addObject:user];
        }
    // Update Parse.com with changes.
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error %@ %@", error, [error userInfo]);}
            }];
}

#pragma mark - Helper methods

- (BOOL)isFriend:(PFUser *)user {
    NSLog(@"isFriend Running!");
    NSLog(@"%@",self.friends); //null, ok so the problem is that self.friends is empty.
    for (PFUser *friend in self.friends) {
            NSLog(@"isFriend Looping!");
        if ([friend.objectId isEqualToString:user.objectId]) {
            NSLog(@"Yes %@ is a friend",user.objectId);
            return YES; //Friend found
        }
    }
   return NO;
}


//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
