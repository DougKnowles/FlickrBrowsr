//
//  FBMainViewController.m
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/3/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import "FBMainViewController.h"

#import "FBAppDelegate.h"

#import "FeedParser/FeedParser.h"


@interface FBMainViewController ()

@end

@implementation FBMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// set up persistence layer and feed query; start query
	FBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	self.managedObjectContext = appDelegate.managedObjectContext;
	NSLog( @"Initialize MOC to %@", self.managedObjectContext );
	
	NSArray *args = [NSArray arrayWithObjects:
					 @"format=rss_200",
					 nil];
	self.feedReader = [[[FBFeedReader alloc] initWithURL:@"http://api.flickr.com/services/feeds/photos_public.gne" andArguments:args] autorelease];
	self.feedReader.delegate = self;
	[self.feedReader startQuery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FBFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (void)dealloc
{
	[_managedObjectContext release];
	[_flipsidePopoverController release];
    [super dealloc];
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

#pragma mark - UICollectionView delegate/datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	NSLog( @"%s", __PRETTY_FUNCTION__ );
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSLog( @"%s", __PRETTY_FUNCTION__ );
	return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog( @"%s for index path %@", __PRETTY_FUNCTION__ , indexPath );
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrImage" forIndexPath:indexPath];
	return cell;
}

#pragma mark - FBFeedReaderDelegate

- (void)feedReader:(FBFeedReader *)loader downloadedData:(NSData *)data
{
	NSError *error = nil;
	FPFeed *feed = [FPParser parsedFeedWithData:data error:&error];
	if  ( feed == nil )  {
		NSLog( @"Error parsing feed: %@", error );
		return;
	}
	// process the results
	NSLog( @"Downloaded feed: %@", feed.description );
	for  ( FPItem *item in feed.items )  {
		NSLog( @"%@ by %@ on %@\n%@\nLinks: %@",
			  item.title, item.creator, item.pubDate, item.description, item.links );
		if  ( item.enclosures.count != 0 )  {
			NSLog( @"Enclosures: %@", item.enclosures );
		}
	}
}

- (void)feedReader:(FBFeedReader *)loader receivedError:(NSError *)error
{
	NSLog( @"%s feed error: %@", __PRETTY_FUNCTION__, error );
}


@end
