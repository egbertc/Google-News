//
//  BookmarksTableViewController.h
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarksTableViewController : UITableViewController
- (IBAction)addBookmark:(id)sender;
- (IBAction)editBookmarks:(id)sender;

@property (strong,nonatomic) NSDictionary* detailItem;

//- (void) setDetailItem:(NSDictionary*)item;

@end
