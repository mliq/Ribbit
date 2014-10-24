//
//  ImageViewController.h
//  Ribbit
//
//  Created by Michael Liquori on 10/23/14.
//  Copyright (c) 2014 Michael Liquori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic,strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
