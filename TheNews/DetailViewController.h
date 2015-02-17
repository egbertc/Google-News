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
- (void)bookmark:(id)sender sendsURL:(NSURL*)url;
@end

@interface DetailViewController : UIViewController <BookmarkToWebViewDelegate>
- (IBAction)tweetArticle:(id)sender;

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebView;



@end

