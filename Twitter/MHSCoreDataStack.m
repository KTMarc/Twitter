//
//  MHSCoreDataStack.m
//
//  Created by Marc Humet on 3/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

#import "MHSCoreDataStack.h"

@interface MHSCoreDataStack ()

@property (strong, nonatomic, readonly) NSManagedObjectModel *model;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *storeCoordinator;
@property (strong, nonatomic) NSURL *modelURL;
@property (strong, nonatomic) NSURL *dbURL;

@end

@implementation MHSCoreDataStack

#pragma mark -  Properties
// When using a readonly property with a custom getter, auto-synthesize
// is disabled.
// See http://www.cocoaosx.com/2012/12/04/auto-synthesize-property-reglas-excepciones/
// (in Spanish)
@synthesize model = _model;
@synthesize storeCoordinator = _storeCoordinator;
@synthesize context = _context;


- (NSManagedObjectContext *)context
{
    if (_context == nil) {
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = self.storeCoordinator;
        
        // Añadir un UndoManager
        _context.undoManager = [[NSUndoManager alloc]init];
    }
    
    return _context;
}

- (NSPersistentStoreCoordinator *)storeCoordinator
{
    if (_storeCoordinator == nil) {
        _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSInferMappingModelAutomaticallyOption : @YES};
        
        NSError *err = nil;
        if (![_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:self.dbURL
                                                   options:options
                                                     error:&err]) {
            // Something went really wrong...
            // Send a notification and return nil
            NSNotification *note = [NSNotification
                                    notificationWithName:[MHSCoreDataStack persistentStoreCoordinatorErrorNotificationName]
                                    object:self
                                    userInfo:@{@"error" : err}];
            [[NSNotificationCenter defaultCenter] postNotification:note];
            NSLog(@"Error while adding a Store: %@", err);
            return nil;
        }
    }
    
    return _storeCoordinator;
}

- (NSManagedObjectModel *)model
{
    if (_model == nil) {
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    }
    
    return _model;
}


#pragma mark - Class Methods

+ (NSString *)persistentStoreCoordinatorErrorNotificationName
{
    return @"persistentStoreCoordinatorErrorNotificationName";
}

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (MHSCoreDataStack *)coreDataStackWithModelName:(NSString *)aModelName databaseFilename:(NSString*) aDBName
{
    NSURL *url = nil;
    
    if (aDBName) {
        url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:aDBName];
    }
    else {
        url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:aModelName];
    }
    
    return [self coreDataStackWithModelName:aModelName
                                databaseURL:url];
}

+ (MHSCoreDataStack *)coreDataStackWithModelName:(NSString *)aModelName
{
    return [self coreDataStackWithModelName:aModelName databaseFilename:nil];
}

+ (MHSCoreDataStack *)coreDataStackWithModelName:(NSString *)aModelName databaseURL:(NSURL *)aDBURL
{
    return [[self alloc] initWithModelName:aModelName databaseURL:aDBURL];
}


#pragma mark - Init

- (id)initWithModelName:(NSString *)aModelName
            databaseURL:(NSURL *)aDBURL
{
    if (self = [super init]) {
        self.modelURL = [[NSBundle mainBundle] URLForResource:aModelName withExtension:@"momd"];
        self.dbURL = aDBURL;
    }
    
    return self;
}

#pragma mark Singleton Method

//As seen in "Effective Objective C (Matt Galloway) - item 45 (making the singleton thread safe)

+(id) sharedInstance{
    static MHSCoreDataStack *sharedCoreData = nil;
    @synchronized(self) {
        if (!sharedCoreData)
            sharedCoreData = [[self alloc] init];
    }
    return sharedCoreData;
}


#pragma mark - Others

- (void)zapAllData
{
    NSError *err = nil;
    for (NSPersistentStore *store in self.storeCoordinator.persistentStores) {
        if (![self.storeCoordinator removePersistentStore:store error:&err]) {
            NSLog(@"Error while removing store %@ from store coordinator %@", store, self.storeCoordinator);
        }
    }
    if (![[NSFileManager defaultManager] removeItemAtURL:self.dbURL error:&err]) {
        NSLog(@"Error removing %@: %@", self.dbURL, err);
    }
    
    // The Core Data stack does not like you removing the file under it. If you want to delete the file
    // you should tear down the stack, delete the file and then reconstruct the stack.
    // Part of the problem is that the stack keeps a cache of the data that is in the file. When you
    // remove the file you don't have a way to clear that cache and you are then putting
    // Core Data into an unknown and unstable state.
    
    _context = nil;
    _storeCoordinator = nil;
    [self context]; // this will rebuild the stack
}


- (void)saveWithErrorBlock:(void(^)(NSError *error))errorBlock
{
    NSError *err = nil;
    // If a context is nil, saving it should also be considered an
    // error, as being nil might be the result of a previous error
    // while creating the db.
    if (!_context) {
        err = [NSError errorWithDomain:@"MHSCoreDataStack"
                                  code:1
                              userInfo:@{NSLocalizedDescriptionKey :
                                             @"Attempted to save a nil NSManagedObjectContext. This MHSCoreDataStack has no context - probably there was an earlier error trying to access the CoreData database file."}];
        errorBlock(err);
        
    }
    else if (self.context.hasChanges) {
        if (![self.context save:&err]) {
            errorBlock(err);
        }
    }
}

-(NSArray *)executeRequest:(NSFetchRequest *)request
                 withError:(void(^)(NSError *error))errorBlock{
    
    NSError *err = nil;
    NSArray *results = nil;
    
    if (!_context) {
        err = [NSError errorWithDomain:@"MHSCoreDataStack"
                                  code:1
                              userInfo:@{NSLocalizedDescriptionKey :
                                             @"Attempted to search a nil NSManagedObjectContext. This MHSCoreDataStack has no context - probably there was an earlier error trying to access the CoreData database file."}];
        errorBlock(err);
        
    }else{
        
        results = [self.context executeFetchRequest:request
                                              error:&err];
        if (!results) {
            errorBlock(err);
        }
    }
    
    return results;
}
@end
