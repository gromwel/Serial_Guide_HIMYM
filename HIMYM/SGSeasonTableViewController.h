//
//  SGSeasonTableViewController.h
//  HIMYM
//
//  Created by Clyde Barrow on 22.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    SGListAllEpisodes,
    SGListSearchEpisodes
} SGListShow;

@interface SGSeasonTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) NSInteger numberSeason;

@end
