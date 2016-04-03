//
//  MHSCoreDataStack.h
//
//  Created by Marc Humet on 3/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

@import CoreData;

#import <Foundation/Foundation.h>

@interface MHSCoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

+ (NSString *)persistentStoreCoordinatorErrorNotificationName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName
                          databaseFilename:(NSString *)aDBName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName
                               databaseURL:(NSURL *)aDBURL;

- (id)initWithModelName:(NSString *)aModelName databaseURL:(NSURL *)aDBURL;

- (void)zapAllData;

- (void)saveWithErrorBlock:(void(^)(NSError *error))errorBlock;
-(NSArray *)executeRequest:(NSFetchRequest *)request
                 withError:(void(^)(NSError *error))errorBlock;

+ (id) sharedInstance;
@end
