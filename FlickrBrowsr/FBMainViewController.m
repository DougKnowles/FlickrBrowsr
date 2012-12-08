//
//  FBMainViewController.m
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/3/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import "FBMainViewController.h"

#import "FBAppDelegate.h"

#import "FBImage+Interface.h"

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
		
	// configure the collection layout
	UICollectionViewFlowLayout *flowLayout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
	CGSize viewSize = self.ibCollectionView.superview.bounds.size;
	CGFloat minDimension = fmin(viewSize.height, viewSize.width) - 44.0;	// yes, this is dirty; adjust for nav bar
	NSUInteger itemsAcross = (minDimension < 400.0) ? 3 : 4;
	CGFloat optimalWidth = (minDimension - (flowLayout.minimumInteritemSpacing * (itemsAcross - 1))) / (CGFloat)itemsAcross;
	flowLayout.itemSize = CGSizeMake(optimalWidth, optimalWidth);
	self.ibCollectionView.collectionViewLayout = flowLayout;

	// listen for image load notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownloadComplete:) name:FBImageDownloadNotification object:nil];
	
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
	[[NSNotificationCenter defaultCenter] removeObserver:self];

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
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.feedContent.count;	
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger index = [indexPath indexAtPosition:1];
	FBImage *imageObject = [self.feedContent objectAtIndex:index];
	
	FBImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrImage" forIndexPath:indexPath];
	cell.ibImageLabel.text = imageObject.title;
	if  ( imageObject.imageData != nil )  {
		UIImage *image = [UIImage imageWithData:imageObject.imageData];
		cell.ibImageView.image = (image != nil) ? image : [UIImage imageNamed:@"PlaceHolder"];
		cell.ibImageView.hidden = NO;
	}
	else  {
		cell.ibImageView.image = nil;
		cell.ibImageView.hidden = YES;
	}
	
	return cell;
}

#pragma mark - FBFeedReaderDelegate

- (void)feedReader:(FBFeedReader *)loader downloadedData:(NSData *)data
{
	NSError *error = nil;
	FPFeed *feed = [FPParser parsedFeedWithData:data error:&error];
	if  ( feed == nil )  {
		// TODO: report error
		NSLog( @"Error parsing feed: %@", error );
		return;
	}
	// process the results to persist them
	for  ( FPItem *item in feed.items )  {
		[FBImage createFBImageWithFPItem:item inContext:self.managedObjectContext];
	}
	// reload the persisted objects
	NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"FBImage"];
	error = nil;
	NSArray *images = [self.managedObjectContext executeFetchRequest:req error:&error];
	if  ( images == nil )  {
		// TODO: report error
		NSLog( @"Error fetching images from store: %@", error );
		return;
	}
	// for now, just replace the old content with the new
	// eventually, we may want to prune the dataset and merge identical results, etc.
	self.feedContent = images;
	[self.ibCollectionView reloadData];
}

- (void)feedReader:(FBFeedReader *)loader receivedError:(NSError *)error
{
	NSLog( @"%s feed error: %@", __PRETTY_FUNCTION__, error );
	// TODO: report error
}

#pragma mark - Notifications

- (void)imageDownloadComplete:(NSNotification *)aNotification
{
	[self.ibCollectionView reloadData];
}


@end


@implementation FBImageCell



@end
