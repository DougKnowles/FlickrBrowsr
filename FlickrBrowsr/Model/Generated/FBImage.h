//
//  FBImage.h
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/5/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FBImage : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * publicationDate;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSString * imageDescription;
@property (nonatomic, retain) NSString * imageURLString;
@property (nonatomic, retain) NSData * imageData;

@end
