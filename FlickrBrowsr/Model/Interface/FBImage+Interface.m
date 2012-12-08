//
//  FBImage+Interface.m
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/5/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import "FBImage+Interface.h"

#import "FPItem.h"
#import "FPLink.h"

#import "FBFeedReader.h"

NSString *	FBImageDownloadNotification = @"FBImageDownloadNotification";


@implementation FBImage (Interface)


+ (FBImage *)createFBImageWithFPItem:(FPItem *)fpItem inContext:(NSManagedObjectContext *)context
{
	FBImage *newImage = [NSEntityDescription insertNewObjectForEntityForName:@"FBImage" inManagedObjectContext:context];
	newImage.title = fpItem.title;
	newImage.publicationDate = fpItem.pubDate;
	newImage.author = fpItem.author;
	newImage.imageDescription = fpItem.description;
	newImage.imageURLString = fpItem.link.href;
	if  ( fpItem.links.count > 1 )  {
		NSLog( @"Item has %ld links!", (long)fpItem.links.count );
	}
	
	if (fpItem.enclosures.count != 0)  NSLog( @"Found enclosures for %@:\n%@", newImage, fpItem.enclosures );
	
	[newImage startImageDownload];
	
	return newImage;
}

#pragma mark - Properties

@dynamic feedReader;

- (FBFeedReader *)feedReader
{
	return self.feedReaderRef;
}

- (void)setFeedReader:(FBFeedReader *)feedReader
{
	self.feedReaderRef = feedReader;
}


#pragma mark - Image download

- (void)startImageDownload
{
	if  ( self.imageURLString.length == 0 )  return;		// no URL to download from

	self.feedReader = [[[FBFeedReader alloc] initWithURL:self.imageURLString andArguments:nil] autorelease];
	self.feedReader.delegate = (id<FBFeedReaderDelegate>)self;
	[self.feedReader startQuery];
}

#pragma mark - FBFeedReaderDelegate

- (void)feedReader:(FBFeedReader *)loader downloadedData:(NSData *)data
{
	NSLog( @"%ld bytes downloaded for: %@", (long)data.length, self.title );
	self.imageData = data;
	self.feedReader = nil;
	// post notification
	[[NSNotificationCenter defaultCenter] postNotificationName:FBImageDownloadNotification object:self];
}

- (void)feedReader:(FBFeedReader *)loader receivedError:(NSError *)error
{
	NSLog( @"%s feed error: %@", __PRETTY_FUNCTION__, error );
	// TODO: report error
}




- (NSString *)description
{
	return [NSString stringWithFormat:@"FBImage: (%@) @ %@ : %@", @"(image)", self.imageURLString, self.imageDescription];
}

@end
