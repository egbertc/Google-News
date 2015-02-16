//
//  SharedNetworking.h
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedNetworking : NSObject

+ (id)sharedSharedNetworking;
- (void)getDataForURL:(NSString*)url success:(void (^)(NSDictionary *data, NSError *error))successCompletion failure:(void (^)(void))failureCompletion;

@end
