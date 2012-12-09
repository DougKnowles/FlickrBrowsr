//
//  FBImageViewController.m
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/8/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import "FBImageViewController.h"

@interface FBImageViewController ()

@end

@implementation FBImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NSLog( @"Setting %@, %@, and %@", self.title, self.author, self.image );
	self.titleLabel.text = self.title;
	self.authorLabel.text = self.author;
	self.imageView.image = self.image;
	[self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
