//
//  DetailViewController.m
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import "DetailViewController.h"
#import "BookmarksTableViewController.h"
#import <Social/Social.h>

@interface DetailViewController ()
@property (strong,nonatomic) NSUserDefaults* defaults;

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
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:[_detailItem objectForKey:@"link" ]] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [self.articleWebView loadRequest:request];
        [_defaults removeObjectForKey:@"lastViewed"];
        [_defaults setObject:_detailItem forKey:@"lastViewed"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _defaults = [NSUserDefaults standardUserDefaults];
    if(_detailItem == nil)
    {
        if ([_defaults objectForKey:@"lastViewed"] != nil)
        {
            _detailItem = [_defaults objectForKey:@"lastViewed"];
        }
    }
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showBookmarks"]) {
        NSLog(@"SEGUE TO BOOKMARKS");
        NSDictionary *article = (NSDictionary*) _detailItem;
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        BookmarksTableViewController *controller = (BookmarksTableViewController *)[segue destinationViewController];// topViewController];
        controller.detailItem = article;
        controller.delegate = self;
        
    }
}

- (void)bookmark:(id)sender sendsURL:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.articleWebView loadRequest:request];
    [self setDetailItem:sender];
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
