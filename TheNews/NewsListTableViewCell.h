//
//  NewsListTableViewCell.h
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *publishedDate;
@property (weak, nonatomic) IBOutlet UILabel *articleSnippet;

@end
