//
//  SGResultSeasonTableViewController.h
//  HIMYM
//
//  Created by Clyde Barrow on 10.01.2018.
//  Copyright © 2018 Clyde Barrow. All rights reserved.
//

#import "SGSeasonTableViewController.h"

typedef enum{
    seasonSearching,
    serialSearching
} SGSeaching;

@interface SGResultSeasonTableViewController : UITableViewController

@property (nonatomic, strong) NSArray * arrayEpisodesSearch;
@property (nonatomic, assign) NSInteger numberSeason;

@property (nonatomic, strong) UISearchBar * searchBar;

@property (nonatomic, assign) SGSeaching searching;

@end
