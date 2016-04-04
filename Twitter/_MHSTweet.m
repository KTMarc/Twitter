// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MHSTweet.m instead.

#import "_MHSTweet.h"

@implementation MHSTweetID
@end

@implementation _MHSTweet

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tweet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:moc_];
}

- (MHSTweetID*)objectID {
	return (MHSTweetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"favoriteCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favoriteCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"retweetCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"retweetCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"tweet_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"tweet_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic favoriteCount;

- (int16_t)favoriteCountValue {
	NSNumber *result = [self favoriteCount];
	return [result shortValue];
}

- (void)setFavoriteCountValue:(int16_t)value_ {
	[self setFavoriteCount:@(value_)];
}

- (int16_t)primitiveFavoriteCountValue {
	NSNumber *result = [self primitiveFavoriteCount];
	return [result shortValue];
}

- (void)setPrimitiveFavoriteCountValue:(int16_t)value_ {
	[self setPrimitiveFavoriteCount:@(value_)];
}

@dynamic name;

@dynamic profile_image_url;

@dynamic retweetCount;

- (int16_t)retweetCountValue {
	NSNumber *result = [self retweetCount];
	return [result shortValue];
}

- (void)setRetweetCountValue:(int16_t)value_ {
	[self setRetweetCount:@(value_)];
}

- (int16_t)primitiveRetweetCountValue {
	NSNumber *result = [self primitiveRetweetCount];
	return [result shortValue];
}

- (void)setPrimitiveRetweetCountValue:(int16_t)value_ {
	[self setPrimitiveRetweetCount:@(value_)];
}

@dynamic timestamp;

@dynamic tweet_id;

- (int16_t)tweet_idValue {
	NSNumber *result = [self tweet_id];
	return [result shortValue];
}

- (void)setTweet_idValue:(int16_t)value_ {
	[self setTweet_id:@(value_)];
}

- (int16_t)primitiveTweet_idValue {
	NSNumber *result = [self primitiveTweet_id];
	return [result shortValue];
}

- (void)setPrimitiveTweet_idValue:(int16_t)value_ {
	[self setPrimitiveTweet_id:@(value_)];
}

@dynamic tweet_text;

@dynamic twitter_handle;

@dynamic user;

@end

@implementation MHSTweetAttributes 
+ (NSString *)favoriteCount {
	return @"favoriteCount";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)profile_image_url {
	return @"profile_image_url";
}
+ (NSString *)retweetCount {
	return @"retweetCount";
}
+ (NSString *)timestamp {
	return @"timestamp";
}
+ (NSString *)tweet_id {
	return @"tweet_id";
}
+ (NSString *)tweet_text {
	return @"tweet_text";
}
+ (NSString *)twitter_handle {
	return @"twitter_handle";
}
+ (NSString *)user {
	return @"user";
}
@end

