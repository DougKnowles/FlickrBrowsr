//
//  FBHTTPLoader.h
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/5/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBFeedReader;


@protocol FBFeedReaderDelegate <NSObject>

- (void)feedReader:(FBFeedReader *)loader downloadedData:(NSData *)data;
- (void)feedReader:(FBFeedReader *)loader receivedError:(NSError *)error;

@end

@interface FBFeedReader : NSObject

@property (readwrite, assign)				id<FBFeedReaderDelegate>	delegate;
@property (readwrite, strong, nonatomic)	NSMutableArray *			arguments;

@property (readonly, strong, nonatomic)		NSData *					queryResults;

- (id)initWithURL:(NSString *)url andArguments:(NSArray *)arguments;
- (void)startQuery;

@end
