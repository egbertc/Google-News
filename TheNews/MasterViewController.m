//
//  MasterViewController.m
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SharedNetworking.h"
#import "NewsListTableViewCell.h"

@interface MasterViewController ()

@property (strong, nonatomic) NSDateFormatter* articleDateFormat;
@property (strong, nonatomic) NSDateFormatter* cellDateFormat;
@property (strong,nonatomic) SharedNetworking *networking;
@property (strong,nonatomic) NSString* newsURL;
@property (strong,nonatomic) NSUserDefaults* defaults;
@property BOOL nightMode;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
    
    _articleDateFormat = [[NSDateFormatter alloc] init];
    [_articleDateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"]; //"Mon, 16 Feb 2015 10:33:43 -0800"
    _cellDateFormat = [[NSDateFormatter alloc] init];
    [_cellDateFormat setDateFormat:@"dd MMM yyyy"];
    
    _newsURL = @"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=8&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss";
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    _networking = [SharedNetworking sharedSharedNetworking];
    _defaults = [NSUserDefaults standardUserDefaults];
    _nightMode = [[_defaults objectForKey:@"night_mode"] boolValue];
    
    [_networking getDataForURL:_newsURL success:^(NSDictionary *data, NSError *error) {
        self.newsList = [[[data objectForKey:@"responseData"] objectForKey:@"feed"] objectForKey:@"entries"];
        //NSLog(@"\nRECIEVED DATA--------------------------\n %@", data);
        NSLog(@"\n DATA LOADED \n");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            //[self loadFirstArticle];
        });
        
    } failure:^{
        //handle network failure
        NSLog(@"NETWORK FAILURE");
    }];
    
    
    //[self.tableView reloadData];
}

- (void)loadFirstArticle
{
    
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *article = (NSDictionary*) [self.newsList objectAtIndex:0];
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
        [controller setDetailItem:article];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    //controller.
}

- (void) loadData
{
    
    [_networking getDataForURL:_newsURL success:^(NSDictionary *data, NSError *error) {
        self.newsList = [[[data objectForKey:@"responseData"] objectForKey:@"feed"] objectForKey:@"entries"];
        //NSLog(@"\nRECIEVED DATA--------------------------\n %@", data);
        NSLog(@"\n DATA LOADED \n");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^{
        //handle network failure
        NSLog(@"NETWORK FAILURE");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *article = (NSDictionary*) [self.newsList objectAtIndex:indexPath.row];
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:article];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (IBAction)reloadTable:(UIRefreshControl *)sender
{
    [self loadData];
    NSLog(@"RELOADING...");
    [self.refreshControl endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [_newsList count];
}

- (NewsListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"TABLEVIEW UPDATE: %@", indexPath);
    NewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell" forIndexPath:indexPath];
    //NSLog(@"Cell Retrieved: %@", cell);
    [self configureCell:cell atIndexPath:indexPath];
    //NSLog(@"Cell Configured");
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(NewsListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
   
    
    NSDictionary *article = (NSDictionary*) [self.newsList objectAtIndex:indexPath.row];
    
    cell.articleTitle.text = [article objectForKey:@"title"];
    //NSLog(@"Title Set: %@", cell.articleTitle.text);
    cell.articleSnippet.text = [article objectForKey:@"contentSnippet"];
    //NSLog(@"Snipped Set: %@",cell.articleSnippet.text);
    NSDate *pubDate = [_articleDateFormat dateFromString:[article objectForKey:@"publishedDate"]];
    cell.publishedDate.text = [_cellDateFormat stringFromDate:pubDate];
    
    if(_nightMode)
    {
        //NSLog(@"NIGHT MODE CELL");
        cell.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:31.0/255.0 blue:75.0/255.0 alpha:1.0];
        cell.articleTitle.textColor = [UIColor whiteColor];
        cell.articleTitle.backgroundColor = cell.backgroundColor;
        cell.articleSnippet.textColor = [UIColor whiteColor];
        cell.publishedDate.textColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
        backView.backgroundColor = [UIColor blackColor];
        cell.selectedBackgroundView = backView;
    }
    
    //NSLog(@"Date Set: %@",cell.publishedDate.text);
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(NewsListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
