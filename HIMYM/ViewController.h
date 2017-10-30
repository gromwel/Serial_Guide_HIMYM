//
//  ViewController.h
//  HIMYM
//
//  Created by Clyde Barrow on 22.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    SGListSeason,   //0
    SGListEpisodes  //1
} SGList;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableViewList;

- (void) showEpisode;

@end

