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


@implementation FBImage (Interface)

+ (FBImage *)createFBImageWithFPItem:(FPItem *)fpItem inContext:(NSManagedObjectContext *)context
{
	FBImage *newImage = [NSEntityDescription insertNewObjectForEntityForName:@"FBImage" inManagedObjectContext:context];
	newImage.title = fpItem.title;
	newImage.publicationDate = fpItem.pubDate;
	newImage.creator = fpItem.creator;
	newImage.imageDescription = fpItem.description;
	newImage.imageURLString = fpItem.link.href;
	
	if (fpItem.enclosures.count != 0)  NSLog( @"Found enclosures for %@:\n%@", newImage, fpItem.enclosures );
	
	return newImage;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"FBImage: (%@) @ %@ : %@", @"(image)", self.imageURLString, self.imageDescription];
}

@end
