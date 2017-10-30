//
//  EpisodeTableViewCell.h
//  HIMYM
//
//  Created by Clyde Barrow on 22.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *epName;
@property (weak, nonatomic) IBOutlet UILabel *epNameEng;
@property (weak, nonatomic) IBOutlet UILabel *epDescription;
@property (weak, nonatomic) IBOutlet UILabel *epNumber;

@end
