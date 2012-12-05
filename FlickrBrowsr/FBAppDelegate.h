//
//  FBAppDelegate.h
//  FlickrBrowsr
//
//  Created by Doug Knowles on 12/3/12.
//  Copyright (c) 2012 Doug Knowles. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBMainViewController;


@interface FBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (assign)	IBOutlet	FBMainViewController *		ibMainViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
