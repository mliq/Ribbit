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
    
    self.recipients = [[NSMutableArray alloc] init];

   }

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    //Query to get friends list
    PFQuery *query = [self.friendsRelation query];
    
    //Order by username
    [query orderByAscending:@"username"];
    
    //Execute in background
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            self.friends = objects; //get friends from objects and put into friends array
            [self.tableView reloadData]; //refresh data
        }
    }];
    
    //Only load image picker if no image saved already
    if (self.image==nil && self.videoFilePath.length==0){
    
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;// Explicitly tells imagePicker that it is delegate of CameraViewController?
        
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
 
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do not highlight row
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    //set cell variable to currently selected cell
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    //Toggle checkmark
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
    
//NSLog(@"%@", self.recipients);
}



                                                                                                             
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section (count of friends list)
    return [self.friends count];
}

// Draw cells based on who is already friends.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    //Ensure that checkmarks are only those we really selected here.
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
//
//    if ([self isFriend:user]) { //if user is a friend
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;//add checkmark
//    }
//    else {
//        cell.accessoryType = UITableViewCellAccessoryNone; //clear checkmark
//    }
    
    return cell;
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

        

    }
     //Dismiss ImagePickerViewController
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancel:(id)sender {
    [self reset];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender {

    //Defensive programming - check before sending to prevent errors

    if(self.image == nil && [self.videoFilePath length]==0) { //No file
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try Again!" message:@"Please capture or select a photo or video to share!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    else { //We do have a file
        [self uploadMessage];
        //moving reset to upload because the self.recipients gets cleared before upload complete due to asynchronocity/background
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark - Helper methods

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width,height);
    CGRect newRectangle = CGRectMake(0,0,width,height);
    UIGraphicsBeginImageContext(newSize);
        [self.image drawInRect:newRectangle];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

- (void)uploadMessage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (self.image !=nil) {     // if image, shrink it
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    }
    else { //VIDEO object
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData contentType:fileType];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your image/video again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {     // upload the file & message details
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your image/video again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    [self reset];
                }
            }];
        }
    }];
}

@end
