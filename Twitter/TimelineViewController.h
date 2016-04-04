//
//  TimelineViewController.h
//  Twitter
//
//  Created by Tripta Gupta on 3/27/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHSCoreDataStack.h"
#import "MHSTweet.h"

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MHSCoreDataStack *model;

- (id)initWithShowMentions:(BOOL)showMentions;

@end
