//
//  BookmarksTableViewController.m
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import "BookmarksTableViewController.h"
#import "BookmarkStorage.h"

@interface BookmarksTableViewController ()

//@property (strong,nonatomic) NSMutableArray* bookmarks;
@property (strong,nonatomic) NSUserDefaults* defaults;
@end

@implementation BookmarksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"VIEW HEIGHT %f", self.view.frame.size.height);
    NSLog(@"TABLEVIEW HEIGHT %f",self.tableView.contentSize.height);//.frame.size.height);
    //_bookmarks = [[NSMutableArray alloc] initWithArray:[_defaults objectForKey:@"bookmarks"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_bookmarks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
    if([[_defaults objectForKey:@"night_mode"] boolValue])
    {
        cell.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:31.0/255.0 blue:75.0/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    NSDictionary *article = [_bookmarks objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [article objectForKey:@"title"];
    
    return cell;
}

- (void) writeBookmarks
{
    BookmarkStorage* bm = [[BookmarkStorage alloc] init];
    bm.bookmarks = _bookmarks;
    NSData* writeData = [NSKeyedArchiver archivedDataWithRootObject:bm];
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    NSURL* file = [docs URLByAppendingPathComponent:@"bookmarks.plist"];
    [writeData writeToURL:file atomically:NO];
}

- (IBAction)addBookmark:(id)sender;
{
    NSLog(@"ADDING ITEM: %@", [_detailItem objectForKey:@"title"]);
    [_bookmarks addObject:_detailItem];
    //[_defaults removeObjectForKey:@"bookmarks"];
    //[_defaults setObject:_bookmarks forKey:@"bookmarks"];
    NSLog(@"Total Bookmarks: %lu",(unsigned long)[_bookmarks count]);
    [self.tableView reloadData];
    [_delegate bookmarkAdded:_detailItem];
    [self writeBookmarks];
}

- (IBAction)editBookmarks:(id)sender;
{
    [self.tableView setEditing:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"DELETE");
    [_bookmarks removeObjectAtIndex:indexPath.row];
    //[_defaults removeObjectForKey:@"bookmarks"];
    //[_defaults setObject:_bookmarks forKey:@"bookmarks"];
    
    [self.tableView reloadData];
    [self writeBookmarks];
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:[[_bookmarks objectAtIndex:indexPath.row ] objectForKey:@"link" ]];
    [_delegate bookmark:[_bookmarks objectAtIndex:indexPath.row ] sendsURL:url withBookmarkList:_bookmarks];
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
