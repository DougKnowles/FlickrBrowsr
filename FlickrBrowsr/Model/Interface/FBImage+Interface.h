//
//  FBImage+Interface.h
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/5/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import "FBImage.h"

@class FPItem;


@interface FBImage (Interface)

+ (FBImage *)createFBImageWithFPItem:(FPItem *)fpItem inContext:(NSManagedObjectContext *)context;

@end
