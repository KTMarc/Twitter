// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MHSTweet.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface MHSTweetID : NSManagedObjectID {}
@end

@interface _MHSTweet : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MHSTweetID*objectID;

@property (nonatomic, strong, nullable) NSNumber* favoriteCount;

@property (atomic) int16_t favoriteCountValue;
- (int16_t)favoriteCountValue;
- (void)setFavoriteCountValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* profile_image_url;

@property (nonatomic, strong, nullable) NSNumber* retweetCount;

@property (atomic) int16_t retweetCountValue;
- (int16_t)retweetCountValue;
- (void)setRetweetCountValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* timestamp;

@property (nonatomic, strong, nullable) NSString* tweet_id;

@property (nonatomic, strong, nullable) NSString* tweet_text;

@property (nonatomic, strong, nullable) NSString* twitter_handle;

@property (nonatomic, strong, nullable) NSString* user;

@end

@interface _MHSTweet (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveFavoriteCount;
- (void)setPrimitiveFavoriteCount:(NSNumber*)value;

- (int16_t)primitiveFavoriteCountValue;
- (void)setPrimitiveFavoriteCountValue:(int16_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveProfile_image_url;
- (void)setPrimitiveProfile_image_url:(NSString*)value;

- (NSNumber*)primitiveRetweetCount;
- (void)setPrimitiveRetweetCount:(NSNumber*)value;

- (int16_t)primitiveRetweetCountValue;
- (void)setPrimitiveRetweetCountValue:(int16_t)value_;

- (NSString*)primitiveTimestamp;
- (void)setPrimitiveTimestamp:(NSString*)value;

- (NSString*)primitiveTweet_id;
- (void)setPrimitiveTweet_id:(NSString*)value;

- (NSString*)primitiveTweet_text;
- (void)setPrimitiveTweet_text:(NSString*)value;

- (NSString*)primitiveTwitter_handle;
- (void)setPrimitiveTwitter_handle:(NSString*)value;

- (NSString*)primitiveUser;
- (void)setPrimitiveUser:(NSString*)value;

@end

@interface MHSTweetAttributes: NSObject 
+ (NSString *)favoriteCount;
+ (NSString *)name;
+ (NSString *)profile_image_url;
+ (NSString *)retweetCount;
+ (NSString *)timestamp;
+ (NSString *)tweet_id;
+ (NSString *)tweet_text;
+ (NSString *)twitter_handle;
+ (NSString *)user;
@end

NS_ASSUME_NONNULL_END
