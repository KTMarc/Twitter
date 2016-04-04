#import "MHSTweet.h"

@interface MHSTweet ()

// Private interface goes here.

@end

@implementation MHSTweet

// Custom logic goes here.
-(id) initWithDictionary:(NSDictionary *)dictionary
                           context:(NSManagedObjectContext *) context{
    
    MHSTweet *tw = [NSEntityDescription insertNewObjectForEntityForName:[MHSTweet entityName]
                                                inManagedObjectContext:context];
    
    tw.user = @"kk" /*[[User alloc] initWithDictionary:dictionary[@"user"]]*/;
    tw.tweet_id           = dictionary[@"id"];
    tw.tweet_text         = dictionary[@"text"];
    tw.profile_image_url  = dictionary[@"user"][@"profile_image_url"];
    tw.twitter_handle     = dictionary[@"user"][@"screen_name"];
    tw.name               = dictionary[@"user"][@"name"];
    tw.timestamp          = dictionary[@"created_at"];
    tw.favoriteCount      = dictionary[@"favorite_count"]; //Int
    tw.retweetCount       = dictionary[@"retweet_count"]; //Int
    
    return tw;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array
                            context:(NSManagedObjectContext *) context
{
    NSLog(@"Starting tweetsWithArray");
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[MHSTweet alloc] initWithDictionary:dictionary context:context]];
    }
    return tweets;
}


@end
