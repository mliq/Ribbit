//
//  CameraViewController.h
//  Ribbit
//
//  Created by Michael Liquori on 10/17/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> //Says CameraViewController will conform to UIImagePickerControllerDelegate, and must also conform to UINavigationControllerDelegate.

@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *videoFilePath;
@property (nonatomic,strong) NSArray *friends;
@property (nonatomic,strong) PFRelation *friendsRelation;
@property (nonatomic,strong) NSMutableArray *recipients;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;


@end
