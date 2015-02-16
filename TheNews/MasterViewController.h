//
//  MasterViewController.h
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

- (IBAction)reloadTable:(UIRefreshControl *)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSMutableArray *newsList;

@end

