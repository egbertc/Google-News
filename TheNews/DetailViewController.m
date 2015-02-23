//
//  DetailViewController.m
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import "DetailViewController.h"
#import "BookmarksTableViewController.h"
#import "BookmarkStorage.h"
#import <Social/Social.h>

@interface DetailViewController ()
@property (strong,nonatomic) NSUserDefaults* defaults;
@property (strong,nonatomic) NSMutableArray* bookmarks;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    
    // Update the user interface for the detail item.
    
    if (self.detailItem)
    {
        self.loadingView.hidden = NO;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:[_detailItem objectForKey:@"link" ]] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [self.articleWebView loadRequest:request];
        
        
        [_defaults removeObjectForKey:@"lastViewed"];
        [_defaults setObject:_detailItem forKey:@"lastViewed"];
        self.navigationItem.title = [_detailItem objectForKey:@"title"];
       // NSLog(@"Load: %@", _detailItem);
        if([_bookmarks containsObject:_detailItem])
        {
            self.favIconView.hidden = NO;
        }
        else
        {
            self.favIconView.hidden = YES;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.articleWebView.delegate = self;
    self.loadingView.layer.cornerRadius = 5;
    self.loadingView.layer.masksToBounds = YES;
    
    _defaults = [NSUserDefaults standardUserDefaults];
    if(_detailItem == nil)
    {
        if ([_defaults objectForKey:@"lastViewed"] != nil)
        {
            _detailItem = [_defaults objectForKey:@"lastViewed"];
        }
    }
    
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    NSURL* file = [docs URLByAppendingPathComponent:@"bookmarks.plist"];
    NSData* data = [[NSData alloc] initWithContentsOfURL:file];
    BookmarkStorage *retrievedBookmarks = (BookmarkStorage*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    _bookmarks = [[NSMutableArray alloc] initWithArray:retrievedBookmarks.bookmarks];
    //_bookmarks = retrievedBookmarks.bookmarks;
    //NSLog(@"BOOKMARKS\n-------------\n%@",_bookmarks);
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadingView.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showBookmarks"]) {
        NSLog(@"SEGUE TO BOOKMARKS");
        NSDictionary *article = (NSDictionary*) _detailItem;
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        BookmarksTableViewController *controller = (BookmarksTableViewController *)[segue destinationViewController];// topViewController];
        controller.detailItem = article;
        controller.delegate = self;
        controller.bookmarks = _bookmarks;
    }
}

- (void)bookmark:(id)sender sendsURL:(NSURL *)url withBookmarkList:(NSMutableArray *)bm
{
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    //[self.articleWebView loadRequest:request];
    [self setDetailItem:sender];
    [self configureView];
    _bookmarks = bm;
}

- (void)bookmarkAdded:(id)sender
{
    _favIconView.hidden = NO;
}

- (IBAction)tweetArticle:(id)sender
{
    //if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    //{
        SLComposeViewController *tweetBox = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSMutableString *initTweet = [NSMutableString stringWithString:@"Check it: "];
        [initTweet appendString:[_detailItem objectForKey:@"link"]];
        [tweetBox setInitialText:initTweet];
        [self presentViewController:tweetBox animated:YES completion:nil];
    //}
}
@end
