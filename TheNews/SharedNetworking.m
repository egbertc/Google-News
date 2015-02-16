//
//  SharedNetworking.m
//  TheNews
//
//  Created by Connor Egbert on 2/16/15.
//  Copyright (c) 2015 Connor Egbert. All rights reserved.
//

#import "SharedNetworking.h"

@implementation SharedNetworking

// -----------------------------------------------------------------------------
#pragma mark - Initialization
// -----------------------------------------------------------------------------
+ (id)sharedSharedNetworking
{
    static dispatch_once_t pred;
    static SharedNetworking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if ( self = [super init] )
    {
        
    }
    return self;
}

// -----------------------------------------------------------------------------
#pragma mark - Requests
// -----------------------------------------------------------------------------

- (void)getDataForURL:(NSString*)url success:(void (^)(NSArray *array, NSError *error))successCompletion failure:(void (^)(void))failureCompletion
{
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode == 200)
        {
            NSError *jsonError;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            NSLog(@"Downloaded:\n -- %@ ",array);
            successCompletion(array,nil);
        }
        else
        {
            NSLog(@"Fail not 200:");
            dispatch_async(dispatch_get_main_queue(), ^{
                if(failureCompletion) failureCompletion();
            });
        }
    }]resume];
}

@end
