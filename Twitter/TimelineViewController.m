//
//  TimelineViewController.m
//  Twitter
//
//  Created by Tripta Gupta on 3/27/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import <UIImageView+AFNetworking.h>
#import "User.h"
#import "TwitterClient.h"
#import "ProfileViewController.h"
#import "MenuViewController.h"
#import "MHSCoreDataStack.h"
#import <NSDate+TimeAgo.h>

@interface TimelineViewController () <UIGestureRecognizerDelegate,NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL showMentions;

//CORE DATA
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) NSNumberFormatter *decimalFormatter;
//@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;

//- (void)onSignOutButton;
- (void)reload;

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Twitter";
        
        self.showMentions = NO;
        [self reload];

    }
    return self;
}

- (id)initWithShowMentions:(BOOL)showMentions
{
    self = [super init];
    if (self) {
        self.title = @"Mentions";
        self.showMentions = showMentions;
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"TweetCell"];
    
    //Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    
   // MHSCoreDataStack *sharedCoreData = [MHSCoreDataStack sharedInstance];
    self.model = [MHSCoreDataStack coreDataStackWithModelName:@"Model"];
    // Returns the URL to the application's Documents directory.
    
    NSLog(@"Core data path:%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);

}

//-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MHSTweet entityName]];
//    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:MHSTweetAttributes.timestamp
//                                                          ascending:YES]];
//    
//    NSFetchedResultsController *results = [[NSFetchedResultsController alloc] initWithFetchRequest:req
//                                                                              managedObjectContext:_model.context
//                                                                                sectionNameKeyPath:nil
//                                                                                         cacheName:nil];
//    self.fetchedResultsController = results;
//}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.searchController.active)
//    {
//        return [self.filteredList count];
//    }
//    else
//    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TweetCell";
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    MHSTweet *tweet;
//    if (self.searchController.active)
//    {
//        country = [self.filteredList objectAtIndex:indexPath.row];
//    }
//    else
//    {
        tweet  = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    }
    
    //Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];

    
    // Setting cell data from Tweet object
    cell.statusLabel.text = tweet.tweet_text;
    cell.statusLabel.font = [UIFont fontWithName:@"Qube" size:16];
    cell.nameLabel.text = tweet.name;
    
    cell.twitterHandleLabel.text = tweet.twitter_handle;
    cell.timeStampLabel.text = [self relativeTimestampWithDate:tweet.timestamp];
    
    //tap on profile for ProfileViewController
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileOnTap:)];
    
    cell.profileImageView.tag = indexPath.row;
    [cell.profileImageView setUserInteractionEnabled:YES];
    [tapgesture setDelegate:self];
    [cell.profileImageView addGestureRecognizer:tapgesture];
    
    [cell.profileImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tweet.profile_image_url]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.profileImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    if (indexPath.row == [self.tweets count] - 1)
    {
        //[self loadMoreTweets];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Tweet *tweet = self.tweets[indexPath.row];
    MHSTweet *tweet  = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSString *text = tweet.tweet_text;
    UIFont *fontText = [UIFont systemFontOfSize:15.0];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(235, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontText}
                                     context:nil];
    
    CGFloat heightOffset = 45;
    return rect.size.height + heightOffset;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row %ld", (long)indexPath.row);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Tweet *tweet = self.tweets[indexPath.row];
    
    TweetViewController *tvc = [[TweetViewController alloc] initWithNibName:@"TweetViewController" andModel:tweet bundle:nil];
    
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController: tvc];
    
    
    [self presentViewController:navigationVC animated:YES completion:nil];
    
    //[navigationVC pushViewController:tvc animated:YES];
    
}

#pragma mark -
#pragma mark === Fetched Results Controller ===
#pragma mark -

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    if (self.model.context)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[MHSTweet entityName] inManagedObjectContext:self.model.context];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: MHSTweetAttributes.timestamp ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                              managedObjectContext:self.model.context
                                                                                sectionNameKeyPath:nil
                                                                                         cacheName:nil];
        frc.delegate = self;
        self.fetchedResultsController = frc;
        
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void) loadMoreTweets {
    if (self.showMentions) {
        // Getting mentions from API
        [[TwitterClient instance] mentionsWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"Loading more tweets");
            
            // Initializing tweet model with array of json
            [self.tweets arrayByAddingObjectsFromArray:[Tweet tweetsWithArray:response]];
            [self setTitle:@"Mentions"];
            
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"No one loves you enough to mention you!");
        }];
    } else {
        // Getting last 20 tweets from home timeline API
        [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"You've go the best json I've ever seen: %@", response);
            
            // Initializing tweet model with array of json
            [self.tweets arrayByAddingObjectsFromArray:[Tweet tweetsWithArray:response]];
            [self setTitle:@"Home"];
            NSLog(@"Loading more tweets without mentions");
            
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"You've been very bad. No tweets for you!");
        }];
    }
    
}

- (void)reload
{
    //Set the flag for loaded Data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *hasData = [defaults objectForKey:@"hasData"];
    NSLog(@"HasData:%@", hasData);
    
    
    if ([hasData isEqualToString:@"no"] || (hasData == nil)){
        NSLog(@"There is no data from previous executions, loading from network..");
        
        if (self.showMentions) {
            // Getting mentions from API
            [[TwitterClient instance] mentionsWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
                //NSLog(@"You've been mentioned by people: %@", response);
                
                // Initializing tweet model with array of json
                self.tweets = [Tweet tweetsWithArray:response];
                [self setTitle:@"Mentions"];
                //[[self navigationController] setTitle:@"Mentions"];
                
                //Saving to Core Data
                [MHSTweet tweetsWithArray:response context:self.model.context];
                NSLog(@"Saved tweets in CORE DATA");
                
                [self.model saveWithErrorBlock:^(NSError *error) {
                    NSLog(@"Error saving %s \n\n %@", __func__, error);
                }];
                
                [defaults setObject:@"yes" forKey:@"hasData"];
                [defaults synchronize];
                
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"No one loves you enough to mention you!");
            }];
        } else {
            // Getting last 20 tweets from home timeline API
            [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
                //NSLog(@"You've go the best json I've ever seen: %@", response);
                
                // Initializing tweet model with array of json
                self.tweets = [Tweet tweetsWithArray:response];
                [self setTitle:@"Home"];
                //[[self navigationController] setTitle:@"Home"];
                
                //Saving to Core Data
                [MHSTweet tweetsWithArray:response context:self.model.context];
                NSLog(@"Saved tweets in CORE DATA");
                [self.model saveWithErrorBlock:^(NSError *error) {
                    NSLog(@"Error saving %s \n\n %@", __func__, error);
                }];
                
                [defaults setObject:@"yes" forKey:@"hasData"];
                [defaults synchronize];
                
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"You've been very bad. No tweets for you!");
            }];
        }
    } else {
        NSLog(@"We have data from previous executions, loading from CORE DATA..");

    }
}

- (void)refreshView
{
    NSLog(@"refreshing view deleting everything in the cache");
    
    [self.model zapAllData]; //Should call a callback to know when deleting ends.
    self.model = [MHSCoreDataStack coreDataStackWithModelName:@"Model"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"no" forKey:@"hasData"];
    [defaults synchronize];
    
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"%@", response);
        
        //Saving to Core Data
        [MHSTweet tweetsWithArray:response context:self.model.context];
        [self.model saveWithErrorBlock:^(NSError *error) {
            NSLog(@"Error saving %s \n\n %@", __func__, error);
        }];
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"!");
    }];
    [self.refreshControl endRefreshing];
}

- (void)profileOnTap:(UIGestureRecognizer *)tap
{
    NSLog(@"Tap that");
    Tweet *tweet = [self.tweets objectAtIndex:tap.view.tag];
    
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = tweet.user;
    
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController: pvc];
    [self presentViewController:navigationVC animated:YES completion:nil];
    //[self.navigationController pushViewController:navigationVC animated:YES];
}

- (void)setTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(title, @"");
    [label sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)relativeTimestampWithDate: (NSString *)date
{
    NSDateFormatter *datefformat = [[NSDateFormatter alloc] init];
    [datefformat setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    [datefformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *tweetDate = [datefformat dateFromString:date];
    return [tweetDate timeAgo];
}



@end
