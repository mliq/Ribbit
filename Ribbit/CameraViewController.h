//
//  CameraViewController.h
//  Ribbit
//
//  Created by Michael Liquori on 10/17/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> //Says CameraViewController will conform to UIImagePickerControllerDelegate, and must also conform to UINavigationControllerDelegate.

@property (strong,nonatomic) UIImagePickerController *imagePicker;

@end
