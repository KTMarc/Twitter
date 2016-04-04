#import "_MHSTweet.h"
#import <UIKit/UIKit.h>


@interface MHSTweet : _MHSTweet

//@property (nonatomic, strong) NSString *relative_timestamp;

-(id) initWithDictionary:(NSDictionary *)dictionary
                         context:(NSManagedObjectContext *) context;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array
                            context:(NSManagedObjectContext *) context;

//-(UIImage *) imageDb;

@end
