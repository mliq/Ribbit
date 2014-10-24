//
//  FriendsViewController.m
//  Ribbit
//
//  Created by Michael Liquori on 10/15/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsTableViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set the friends relation first time view loads only
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
}
//- (IBAction)Edit:(id)sender {
//    [self performSegueWithIdentifier:@"editFriends" sender:sender];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            self.friends = objects; //get friends from objects and put into friends array
            [self.tableView reloadData]; //refresh data
        }
    }];

}


// method to segue to showEditFriends

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //Bug is if we allow the default: sender:(id)sender
//    NSLog(@"Button clicked %@", sender); //Log to determine the sender.
    if ([segue.identifier isEqualToString:@"editFriends"]) {
        NSLog(@"Segue is working!");
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        EditFriendsTableViewController *controller = (EditFriendsTableViewController *)navController.topViewController;
        controller.friends = [NSMutableArray arrayWithArray:self.friends];
        
        /* Error that friends is not a property
        EditFriendsTableViewController *controller = (EditFriendsTableViewController *)segue.destinationViewController;
        EditFriendsTableViewController.friends = [NSMutableArray arrayWithArray:self.friends]; //Sets friends in the Edit viewcontroller equal to friends from this one.
        */
        
        //EditFriendsTableViewController *viewController =
        //[[viewController alloc] initWithNib:[@"EditFriendsTableViewController" bundle:nil];
                                                          
        //(EditFriendsTableViewController *)segue.destinationViewController; //segue.destinationViewController;

    }
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
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    
    return cell;
}


@end

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

