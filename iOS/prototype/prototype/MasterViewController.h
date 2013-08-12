//
//  MasterViewController.h
//  prototype
//
//  Created by Brandon Smith on 3/20/13.
//  Copyright (c) 2013 Brandon Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
