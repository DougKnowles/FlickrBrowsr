//
//  FBMainViewController.h
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/3/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import "FBFlipsideViewController.h"

@interface FBMainViewController : UIViewController <FBFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end