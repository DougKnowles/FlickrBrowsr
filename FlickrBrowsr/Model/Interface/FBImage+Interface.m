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

- (UIImage *)image
{
	UIImage *result = nil;
	id candidate = [NSKeyedUnarchiver unarchiveObjectWithData:self.imageData];
	if  ([candidate isKindOfClass:[UIImage class]]) result = candidate;
	return result;
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
	self.feedReader = nil;		// done with reader
								// try parsing data as an image
	UIImage *image = [UIImage imageWithData:data];
	if  ( image != nil )  {
		// have it! encode and save
		NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:image];
		self.imageData = imageData;
		[[NSNotificationCenter defaultCenter] postNotificationName:FBImageDownloadNotification object:self];
	}
	else  {
		// not an image; probably the page HTML
		NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:data] autorelease];
		xmlParser.delegate = (id<NSXMLParserDelegate>)self;
		self.xmlParserRef = xmlParser;
		[xmlParser parse];
	}
	// post notification
}

- (void)feedReader:(FBFeedReader *)loader receivedError:(NSError *)error
{
	NSLog( @"%s feed error: %@", __PRETTY_FUNCTION__, error );
	// TODO: report error
}


#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	NSString *property = [attributeDict objectForKey:@"property"];
	if  ( (property != nil) && [property isEqualToString:@"og:image"] )  {
		NSString *imageURL = [attributeDict objectForKey:@"content"];
		if  ( imageURL.length > 0 )  {
			// start download of the actual image
			[parser abortParsing];
			self.xmlParserRef = nil;
			self.imageURLString = imageURL;
			[self startImageDownload];
		}	// if imageURL
	}	//if og.image
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	self.xmlParserRef = nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"FBImage: (%@) @ %@ : %@", @"(image)", self.imageURLString, self.imageDescription];
}

@end
