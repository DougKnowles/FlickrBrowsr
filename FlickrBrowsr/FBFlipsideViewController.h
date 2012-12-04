//
//  FBFlipsideViewController.h
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/3/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBFlipsideViewController;

@protocol FBFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FBFlipsideViewController *)controller;
@end

@interface FBFlipsideViewController : UIViewController

@property (assign, nonatomic) id <FBFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
