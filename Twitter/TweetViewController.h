//
//  TweetViewController.h
//  Twitter
//
//  Created by Tripta Gupta on 3/27/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "MHSTweet.h"

@interface TweetViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andModel:(MHSTweet *)tweet bundle:(NSBundle *)nibBundleOrNil;

@end
