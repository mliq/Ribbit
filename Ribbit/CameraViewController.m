//
//  CameraViewController.m
//  Ribbit
//
//  Created by Michael Liquori on 10/17/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set the friends relation first time view loads only
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
}

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
 
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;// Explicitly tells CameraViewController that this image picker is its delegate

     //set no allows editing, can cause memory issues, and max Video Duration
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.videoMaximumDuration = 10;
    
    //Need to set if for devices that do not have camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //set source type to camera. Other options photoLibrary, photosAlbum.
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        
    }
    //Media types
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    
    //Method to present modally. Don't want the animation which would show table view first and confuse user. Completion is an optional block to run after imagePicker display is complete.
    [self presentViewController:self.imagePicker animated:NO completion:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {

        //A photo was taken or selected!
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];

        if (self.imagePicker.sourceType ==UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        //Dismiss ImagePickerViewController
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {

        //A video was taken or selected!
        
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        self.videoFilePath = [imagePickerURL path];
        
        //WARNING: self.videoFilePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];

        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // save the video, first
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                //Above is an Apple-recommended check, because some devices cannot play videos.
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
        //Dismiss ImagePickerViewController
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}
@end
