//
//  CDTMasterViewController.h
//  CoreDataTemplate
//
//  Created by Brandon Smith on 8/5/13.
//  Copyright (c) 2013 Brandon Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface CDTMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
