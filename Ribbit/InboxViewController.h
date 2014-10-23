//
//  InboxViewController.h
//  Ribbit
//
//  Created by Michael Liquori on 10/6/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface InboxViewController : UITableViewController

@property (nonatomic,strong) NSArray *messages;
@property (nonatomic,strong) PFObject *selectedMessage;

- (IBAction)logout:(id)sender;

@end
