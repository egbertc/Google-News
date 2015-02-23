//
//  BookmarkStorage.h
//  TheNews
//
//  Created by Connor Egbert on 2/23/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookmarkStorage : NSObject <NSCoding>

@property (strong,nonatomic) NSMutableArray *bookmarks;

- (void) encodeWithCoder:(NSCoder *)encoder;
- (id) initWithCoder:(NSCoder *)decoder;

@end
