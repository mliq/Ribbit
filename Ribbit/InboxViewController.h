//
//  InboxViewController.h
//  Ribbit
//
//  Created by Michael Liquori on 10/6/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxViewController : UITableViewController

@property (nonatomic,strong) NSArray *messages;

- (IBAction)logout:(id)sender;

@end
