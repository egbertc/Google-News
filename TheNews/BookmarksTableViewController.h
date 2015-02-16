//
//  BookmarksTableViewController.h
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface BookmarksTableViewController : UITableViewController
- (IBAction)addBookmark:(id)sender;
- (IBAction)editBookmarks:(id)sender;

@property (weak,nonatomic) id<BookmarkToWebViewDelegate> delegate;
@property (strong,nonatomic) NSDictionary* detailItem;

//- (void) setDetailItem:(NSDictionary*)item;

@end
