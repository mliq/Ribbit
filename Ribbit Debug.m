/*
Strange click behavior:  
I have to click on one message first, nothing happens, 
then click on another message, then the image loads.

Why could this be?

*/

// Code from previous problem with this...
UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
EditFriendsViewController *controller = (EditFriendsViewController *)navController.topViewController;
controller.friends = [NSMutableArray arrayWithArray:self.friends];