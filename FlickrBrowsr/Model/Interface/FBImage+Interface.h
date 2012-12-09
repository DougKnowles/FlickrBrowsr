//
//  FBImage+Interface.h
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/5/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import "FBImage.h"

@class FPItem;
@class FBFeedReader;

extern	NSString *	FBImageDownloadNotification;

@interface FBImage (Interface)

@property (readwrite, strong)	FBFeedReader *		feedReader;
@property (readonly, assign)	UIImage *			image;


+ (FBImage *)createFBImageWithFPItem:(FPItem *)fpItem inContext:(NSManagedObjectContext *)context;

- (void)startImageDownload;

@end
