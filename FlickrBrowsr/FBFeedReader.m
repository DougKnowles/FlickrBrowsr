//
//  FBHTTPLoader.m
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/5/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import "FBFeedReader.h"

@interface FBFeedReader ()

@property (readwrite, strong, nonatomic)	NSString *					baseURLString;

@property (readwrite, strong, nonatomic)	NSMutableURLRequest *		urlRequest;
@property (readwrite, strong, nonatomic)	NSURLConnection *			urlConnection;

@property (readwrite, strong, nonatomic)	NSMutableData *				incomingData;

- (void)constructURLRequest;
- (void)constructConnection;

@end


@implementation FBFeedReader

- (id)initWithURL:(NSString *)url andArguments:(NSArray *)arguments
{
	if  ( (self = [super init]) != nil )  {
		self.baseURLString = url;
		self.arguments = [NSMutableArray arrayWithArray:arguments];
	}
	return self;
}

- (void)startQuery
{
	if  ( self.urlRequest == nil )  {
		[self constructURLRequest];
		self.urlConnection = nil;
	}
	if  ( self.urlConnection == nil )  [self constructConnection];
	// TODO: start connection on its own thread
	self.incomingData = [NSMutableData dataWithCapacity:4096];
	[self.urlConnection start];
}

- (void)stopQuery
{
	
}

- (void)constructURLRequest
{
	// construct URL request with (optional) arguments
	NSMutableString *urlString = [NSMutableString stringWithString:self.baseURLString];
	BOOL first = YES;
	for  ( NSString *arg in self.arguments )  {
		[urlString appendFormat:@"%@%@", (first ? @"?": @"&"), [arg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		first = NO;
	}
	
	NSLog( @"Composed URL: %@", urlString );
	NSURL *url = [NSURL URLWithString:urlString];
	self.urlRequest = [NSMutableURLRequest requestWithURL:url];
}

- (void)constructConnection
{
	self.urlConnection = [[[NSURLConnection alloc] initWithRequest:self.urlRequest delegate:self] autorelease];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog( @"%s", __PRETTY_FUNCTION__ );
	[self.incomingData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog( @"%s with %ld bytes", __PRETTY_FUNCTION__, (long)data.length );
	[self.incomingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog( @"%s with %@", __PRETTY_FUNCTION__, error );
	if  ( self.delegate != nil )  [self.delegate feedReader:self receivedError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog( @"%s, %ld bytes downloaded", __PRETTY_FUNCTION__, (long)self.incomingData.length );
	if  ( self.delegate != nil )  [self.delegate feedReader:self downloadedData:self.incomingData];
}

@end
