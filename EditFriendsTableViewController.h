//
//  EditFriendsTableViewController.h
//  Ribbit
//
//  Created by Michael Liquori on 10/14/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsTableViewController : UITableViewController

@property (nonatomic,strong) NSArray *allUsers;
@property (nonatomic,strong) PFUser *currentUser;
@end
