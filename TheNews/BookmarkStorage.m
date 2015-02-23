//
//  BookmarkStorage.m
//  TheNews
//
//  Created by Connor Egbert on 2/23/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import "BookmarkStorage.h"

@implementation BookmarkStorage

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_bookmarks forKey:@"bookmarks"];
}

- (id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    self.bookmarks = [decoder decodeObjectForKey:@"bookmarks"];
    
    return self;
}

@end
