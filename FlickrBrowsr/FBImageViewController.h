//
//  FBImageViewController.h
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/8/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBImageViewController : UIViewController

@property (readwrite, strong)	NSString *	author;
@property (readwrite, strong)	NSString *	imageTitle;
@property (readwrite, strong)	UIImage	*	image;

@property (assign)	IBOutlet	UILabel *		authorLabel;
@property (assign)	IBOutlet	UILabel *		titleLabel;
@property (assign)	IBOutlet	UIImageView *	imageView;

@end
