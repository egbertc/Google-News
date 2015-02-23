//
//  DetailViewController.h
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookmarkToWebViewDelegate <NSObject>
@required
- (void)bookmark:(id)sender sendsURL:(NSURL*)url withBookmarkList:(NSMutableArray*)bm;
- (void)bookmarkAdded:(id)sender;
@end

@interface DetailViewController : UIViewController <BookmarkToWebViewDelegate,UIWebViewDelegate>
- (IBAction)tweetArticle:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *favIconView;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;



@end

