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
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;// Explicitly tells CameraViewController that this image picker is its delegate
    //set no allows editing, can cause memory issues
    self.imagePicker.allowsEditing = NO;
    
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
    return 0;
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {

        //A video was taken or selected!
        
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        self.videoFilePath = [imagePickerURL path];
        
        //WARNING: self.videoFilePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];

        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // save the video
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
}
@end
