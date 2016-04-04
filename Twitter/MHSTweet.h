#import "_MHSTweet.h"
#import <UIKit/UIKit.h>

@interface MHSTweet : _MHSTweet

// Custom logic goes here.
//+(instancetype) tweetWithName:(NSString *)name
//                     context:(NSManagedObjectContext *) context;

+(instancetype) tweetWithDictionary:(NSDictionary *)dictionary
                         context:(NSManagedObjectContext *) context;

//-(UIImage *) imageDb;

@end
